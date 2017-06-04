require 'rails_helper'

feature 'Create customer', js: true do
  let!(:company) { FactoryGirl.create(:company) }
  let(:customer_attr) { FactoryGirl.attributes_for(:customer) }

  scenario 'Visitor can create an customer' do
    Company.elasticsearch_reindex
    sleep 2
    visit customers_path
    find('.create-customer').click
    expect(page).to have_css '.customer-form'
    within '.customer-form' do
      fill_in 'customer_first_name', with: customer_attr[:first_name]
      fill_in 'customer_last_name', with: customer_attr[:last_name]
      fill_in 'company-autocomplete', with: company.name
      expect(page).to have_css '.tt-menu .tt-dataset'
      find('.tt-suggestion', text: company.name).click
      find('.submit').click
    end
    expect(page).to have_css '.customers-table'
    within '.customers-table' do
      expect(page).to have_content customer_attr[:first_name]
    end
  end
end