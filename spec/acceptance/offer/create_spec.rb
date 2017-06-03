require 'rails_helper'

feature 'Create offer', js: true do
  let!(:customer) { FactoryGirl.create(:customer) }
  let(:offer_attr) { FactoryGirl.attributes_for(:offer, customer: nil) }

  scenario 'Visitor can create an offer' do
    Customer.elasticsearch_reindex
    visit root_path
    find('.create-offer').click
    expect(page).to have_css '.offer-form'
    within '.offer-form' do
      fill_in 'offer_title', with: offer_attr[:title]
      fill_in 'offer_description', with: offer_attr[:description]
      fill_in 'customers-autocomplete', with: customer.name
      expect(page).to have_css '.tt-menu .tt-dataset'
      find('.tt-suggestion', text: customer.name_with_company).click
      find('.submit').click
    end
    expect(page).to have_css '.offers-table'
    within '.offers-table' do
      expect(page).to have_content offer_attr[:title]
    end
  end
end