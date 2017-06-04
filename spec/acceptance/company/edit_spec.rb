require 'rails_helper'

feature 'Edit company', js: true do
  let!(:company) { FactoryGirl.create(:company) }
  let(:company_attr) { FactoryGirl.attributes_for(:company) }

  scenario 'Visitor can update an company' do
    visit companies_path
    within '.companies-table' do
      expect(page).to have_content company.id
      find('.company-edit').click
    end
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