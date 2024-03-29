require 'rails_helper'

RSpec.describe Purchase, type: :model do
  let(:purchase) { build :purchase, amount_cents: 123 }
  it { expect(purchase).to belong_to :offer }
  it { expect(purchase).to have_db_column(:currency).of_type(:string).with_options(null: false) }
  it { expect(purchase).to have_db_column(:amount_cents).of_type(:integer).with_options(null: false) }
  it { expect(purchase).to have_db_column(:monthly_payments).of_type(:integer) }
  it { expect(purchase).to have_db_column(:initial_amount_cents).of_type(:integer) }
  it { expect(purchase).to have_db_column(:payment_due).of_type(:date) }
  it { expect(purchase).to have_db_column(:cancelled_at).of_type(:datetime) }
  it { expect(purchase).to have_db_column(:token).of_type(:string) }
  it { expect(purchase).to have_many(:renewals) }
  it { expect(purchase).to have_many(:subscriptions).through(:renewals) }
  it { expect(purchase).to have_many(:product_orders) }
  it { expect(purchase).to have_many(:products).through(:product_orders) }
  it { expect(purchase).to validate_presence_of :offer }
  it 'validates uniqueness of token' do
    create :purchase, token: 'test'
    expect(purchase).not_to allow_value('test').for(:token).with_message(:taken)
  end
  it { expect(purchase).to be_valid }
  it 'formats amounts' do
    purchase.amount_cents = '123456'
    expect(purchase.amount).to eq '$1,234.56'
  end
  it 'translates currency names' do
    purchase.currency = 'BTC'
    expect(purchase.currency_name).to eq 'Bitcoin (BTC)'
  end
  it 'formats initial amounts' do
    purchase.initial_amount = '123:456'
    expect(purchase.initial_amount).to eq '$1,234.56'
  end
  it 'shows pending purchases' do
    expect(purchase.to_s).to eq "#{purchase.currency} #{purchase.amount} (payment due " +
      I18n.l(purchase.payment_due, format: :long) + ')'
  end
  it 'shows completed purchases' do
    purchase.payment_due = nil
    expect(purchase.to_s).to eq "#{purchase.currency} #{purchase.amount} (completed)"
  end
  it 'shows cancelled purchases' do
    purchase.cancelled_at = Time.zone.now
    expect(purchase.to_s).to eq "#{purchase.currency} #{purchase.amount} (cancelled at " +
      I18n.l(purchase.cancelled_at, format: :long) + ')'
  end
  it 'shows reversed purchases' do
    purchase.payment_due = nil
    purchase.cancelled_at = Time.zone.now
    expect(purchase.to_s).to eq "#{purchase.currency} #{purchase.amount} (reversed at " +
      I18n.l(purchase.cancelled_at, format: :long) + ')'
  end
end
