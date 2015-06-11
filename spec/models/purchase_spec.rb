require 'rails_helper'

RSpec.describe Purchase, type: :model do
  let(:purchase) { build(:purchase) }
  it { expect(purchase).to belong_to(:offer) }
  it { expect(purchase).to have_db_column(:price_name).of_type(:string).with_options(null: false) }
  it { expect(purchase).to have_db_column(:discount_name).of_type(:string) }
  it { expect(purchase).to have_db_column(:currency).of_type(:string).with_options(null: false) }
  it { expect(purchase).to have_db_column(:amount_cents).of_type(:integer).with_options(null: false) }
  it { expect(purchase).to have_db_column(:completed_at).of_type(:datetime) }
  it { expect(purchase).to have_many(:customer_purchases) }
  it { expect(purchase).to have_many(:customers).through(:customer_purchases) }
  it { expect(purchase).to accept_nested_attributes_for(:customers) }
  it { expect(purchase).to validate_presence_of(:offer) }
  it { expect(purchase).to be_valid }
  it('translates currency names') do
    purchase.currency = 'BTC'
    expect(purchase.currency_name).to eq 'Bitcoin (BTC)'
  end
end
