require 'rails_helper'

RSpec.feature 'Administer purchase', type: :feature do
  scenario 'require login' do
    visit admin_purchases_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create :admin_user, confirmed_at: Time.zone.now }
    given(:purchase) { create :purchase }
    background do
      purchase
      login_as admin_user, scope: :admin_user
    end

    context 'when showing index' do
      background { visit admin_purchases_path }
      [ :offer, :currency, :amount, :total, :paid, :balance, :payment_due, :cancelled_at, :created_at, :updated_at ]
        .each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario('filter by offer')             { expect(page).to have_field 'q_offer_id' }
      scenario('filter by products')          { expect(page).to have_field 'q_product_ids' }
      scenario('filter by currency')          { expect(page).to have_field 'q_currency' }
      scenario('filter by amount')            { expect(page).to have_field 'q_amount_cents' }
      scenario('filter by paid')              { expect(page).to have_field 'q_paid_cents' }
      scenario('filter by payment due')       { expect(page).to have_field 'q_payment_due_gteq' }
      scenario('filter by cancellation time') { expect(page).to have_field 'q_cancelled_at_gteq' }
      scenario('filter by creation time')     { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filter by update time')       { expect(page).to have_field 'q_updated_at_gteq' }
    end

    context 'when viewing record' do
      given(:customer) { create :customer }
      given(:product) { create :product }
      background { visit admin_purchase_path(purchase) }
      [ :offer, :currency, :amount, :monthly_payments, :initial_amount, :total, :paid, :balance, :payment_due,
        :subscriptions, :products, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end

      context 'when there are transactions' do
        background do
          create :transaction, purchase: purchase, message: 'Test message'
          visit admin_purchase_path(purchase)
        end
        scenario { expect(page).to have_css :th, text: 'Transactions' }
        scenario { expect(page).to have_text 'Test message' }
      end

      context 'when not completed or cancelled' do
        scenario { expect(page).to have_field :purchases_with_total_timestamp }
        scenario { expect(page).to have_css 'input[type=submit][value="Create transaction"]' }
        scenario { expect(page).to have_css 'input[type=submit][value="Cancel purchase"]' }
      end

      context 'when completed' do
        background do
          purchase.update! payment_due: nil
          visit admin_purchase_path(purchase)
        end
        scenario { expect(page).to have_field :purchases_with_total_timestamp }
        scenario { expect(page).not_to have_css 'input[type=submit][value="Create transaction"]' }
        scenario { expect(page).to have_css 'input[type=submit][value="Reverse purchase"]' }
      end

      context 'when cancelled' do
        background do
          purchase.update! cancelled_at: Time.zone.now
          visit admin_purchase_path(purchase)
        end
        scenario { expect(page).not_to have_field :purchases_with_total_timestamp }
        scenario { expect(page).not_to have_css 'input[type=submit][value="Cancel purchase"]' }
        scenario { expect(page).not_to have_css 'input[type=submit][value="Reverse purchase"]' }
      end

      scenario 'names associated customers and products' do
        create(:product_order, customer: customer, purchase: purchase, product: product)
        visit admin_purchase_path(purchase)
        expect(page).to have_text "#{product.name} for #{customer.name}: pending"
      end

      scenario 'reports product order shipped dates' do
        create(:product_order, customer: customer, purchase: purchase, product: product, shipped: Time.zone.today)
        visit admin_purchase_path(purchase)
        expect(page).to have_text "shipped #{I18n.l Time.zone.today, format: :long}"
      end
    end

    context 'when cancelling purchase' do
      scenario 'redirects back to record' do
        visit admin_purchase_path(purchase)
        click_on 'Cancel purchase'
        expect(current_path).to eq admin_purchase_path(purchase)
      end
    end

    context 'when completing purchase' do
      scenario 'redirects back to record' do
        visit admin_purchase_path(purchase)
        click_on 'Create transaction'
        expect(current_path).to eq admin_purchase_path(purchase)
      end
    end
  end
end
