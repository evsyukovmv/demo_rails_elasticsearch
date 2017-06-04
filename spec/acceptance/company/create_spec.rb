require 'rails_helper'

feature 'Create company', js: true do
  let(:company_attr) { FactoryGirl.attributes_for(:company) }

  scenario 'Visitor can create an company' do
    visit companies_path
    find('.create-company').click
    expect(page).to have_css '.company-form'
    within '.company-form' do
      fill_in 'company_name', with: company_attr[:name]
      fill_in 'company_address', with: company_attr[:address]
      find('.submit').click
    end
    expect(page).to have_css '.companies-table'
    within '.companies-table' do
      expect(page).to have_content company_attr[:name]
    end
  end
end