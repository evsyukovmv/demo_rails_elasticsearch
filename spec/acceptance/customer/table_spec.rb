require 'rails_helper'

feature 'Customers list', js: true do
  let!(:customers) { FactoryGirl.create_list(:customer, 2) }

  scenario 'Visitor can see all customers on the page' do
    visit customers_path
    within '.customers-table' do
      customers.each do |customer|
        expect(page).to have_content customer.id
        expect(page).to have_content customer.name
      end
    end
  end

  scenario 'Visitor can filter customers' do
    Customer.elasticsearch_reindex
    sleep 2
    visit customers_path
    fill_in('customers-search', with: customers[0].name)
    find('#customers-search').native.send_keys(:return)
    within '.customers-table' do
      expect(page).not_to have_content customers[1].name
      expect(page).to have_content customers[0].name
    end
  end
end