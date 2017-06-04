require 'rails_helper'

feature 'Edit customer', js: true do
  let!(:customer) { FactoryGirl.create(:customer) }
  let(:customer_attr) { FactoryGirl.attributes_for(:customer) }

  scenario 'Visitor can update an customer' do
    visit customers_path
    within '.customers-table' do
      expect(page).to have_content customer.id
      find('.customer-edit').click
    end
    expect(page).to have_css '.customer-form'
    within '.customer-form' do
      fill_in 'customer_first_name', with: customer_attr[:first_name]
      fill_in 'customer_last_name', with: customer_attr[:last_name]
      find('.submit').click
    end
    expect(page).to have_css '.customers-table'
    within '.customers-table' do
      expect(page).to have_content customer_attr[:title]
    end
  end
end