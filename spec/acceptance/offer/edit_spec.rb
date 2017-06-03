require 'rails_helper'

feature 'Edit offer', js: true do
  let!(:offer) { FactoryGirl.create(:offer) }
  let(:offer_attr) { FactoryGirl.attributes_for(:offer, customer: nil) }

  scenario 'Visitor can update an offer' do
    visit root_path
    within '.offers-table' do
      expect(page).to have_content offer.id
      find('.offer-edit').click
    end
    expect(page).to have_css '.offer-form'
    within '.offer-form' do
      fill_in 'offer_title', with: offer_attr[:title]
      fill_in 'offer_description', with: offer_attr[:description]
      find('.submit').click
    end
    expect(page).to have_css '.offers-table'
    within '.offers-table' do
      expect(page).to have_content offer_attr[:title]
    end
  end
end