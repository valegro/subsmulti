require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  describe 'GET #index' do
    let(:price) { create(:price) }
    it('responds successfully') { expect(get :index).to be_success }
    it 'assigns @offers in order of finish' do
      offer1 = create(:offer, finish: Time.zone.today + 2.days)
      create(:offer) # No price
      offer2 = create(:offer, finish: Time.zone.today + 1.day)
      create(:offer_price, offer: offer1, price: price)
      create(:offer_price, offer: offer2, price: price)
      get :index
      expect(assigns(:offers)).to eq [offer2, offer1]
    end
    it('renders the index template') { expect(get :index).to render_template('index') }
  end

  describe 'GET #show' do
    let(:offer) { create(:offer) }
    context 'when there are no prices' do
      it 'redirects to the index page' do
        get :show, id: offer
        expect(response).to redirect_to offers_path
      end
    end
    context 'when there is at least one price' do
      let(:price) { create(:price) }
      let(:offer_price) { create(:offer_price, offer: offer, price: price) }
      let(:product) { create(:product) }
      let(:offer_product) { create(:offer_product, offer: offer, product: product) }
      before do
        offer_price
        offer_product
        get :show, id: offer
      end
      it('responds successfully') { expect(response).to be_success }
      it('assigns the requested offer to @offer') { expect(assigns(:offer)).to eq offer }
      it('assigns offer products to @products') { expect(assigns(:products)).to eq [offer_product] }
      it('renders the show template') { expect(response).to render_template('show') }
    end
  end
end
