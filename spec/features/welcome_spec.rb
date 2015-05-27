require 'rails_helper'
require 'faker'

RSpec.feature 'Welcome page', type: :feature do
  given(:campaign1) { create(:campaign, description: Faker::Lorem.sentences) }
  given(:campaign2) { create(:campaign, description: Faker::Lorem.sentences) }
  given(:offer1) { create(:offer) }
  given(:offer2) { create(:offer) }
  background do
    create(:campaign_offer, campaign: campaign1, offer: offer1)
    create(:campaign_offer, campaign: campaign2, offer: offer1)
    create(:campaign_offer, campaign: campaign2, offer: offer2)
    visit root_path
  end
  scenario 'shows provider name' do
    expect(page).to have_text Configuration.provider_name
  end
  scenario 'lists campaigns with descriptions' do
    expect(page).to have_text campaign1.name
    expect(page).to have_text campaign1.description
    expect(page).to have_text campaign2.name
    expect(page).to have_text campaign2.description
  end
  scenario 'has a link to each campaign' do
    expect(page).to have_link campaign1.name, href: campaign_path(campaign1)
    expect(page).to have_link campaign2.name, href: campaign_path(campaign2)
  end
  scenario 'lists offers for each campaign' do
    expect(page).to have_text offer1.name
    expect(page).to have_text offer2.name
  end
  scenario 'has a link to each offer' do
    expect(page).to have_link offer1.name, href: offer_path(offer1)
    expect(page).to have_link offer2.name, href: offer_path(offer2)
  end
end
