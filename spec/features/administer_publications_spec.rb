require 'rails_helper'

RSpec.feature 'Administer publication', type: :feature do
  scenario 'require login' do
    visit admin_publications_path
    expect(current_path).to eq new_admin_user_session_path
  end

  context 'when logged in' do
    given(:admin_user) { create(:admin_user, confirmed_at: Time.zone.now) }
    given(:publication) { create(:publication) }
    background do
      publication
      login_as admin_user, scope: :admin_user
    end

    context 'when showing index' do
      background { visit admin_publications_path }
      [ :name, :image, :website, :offers, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
      scenario('filter by name')                { expect(page).to have_field 'q_name' }
      scenario('filter by image filename')      { expect(page).to have_field 'q_image_file_name' }
      scenario('filter by image content type')  { expect(page).to have_field 'q_image_content_type' }
      scenario('filter by image file size')     { expect(page).to have_field 'q_image_file_size' }
      scenario('filter by image update time')   { expect(page).to have_field 'q_image_updated_at_gteq' }
      scenario('filter by website')             { expect(page).to have_field 'q_website' }
      scenario('filter by offer')               { expect(page).to have_field 'q_offer_ids' }
      scenario('filter by creation time')       { expect(page).to have_field 'q_created_at_gteq' }
      scenario('filter by update time')         { expect(page).to have_field 'q_updated_at_gteq' }
    end

    context 'when viewing record' do
      background { visit admin_publication_path(publication) }
      [ :name, :image, :website, :offers, :description, :created_at, :updated_at ].each do |field|
        scenario { expect(page).to have_css :th, text: field.to_s.titlecase }
      end
    end

    context 'when editing record' do
      background do
        visit edit_admin_publication_path(publication)
      end
      scenario { expect(page).to have_field 'publication_name' }
      scenario { expect(page).to have_field 'publication_image' }
      scenario { expect(page).to have_field 'publication_website' }
      scenario { expect(page).to have_field 'publication_description' }
    end
  end
end