require 'rails_helper'

feature 'Companies list', js: true do
  let!(:companies) { FactoryGirl.create_list(:company, 2) }

  scenario 'Visitor can see all companies on the page' do
    visit companies_path
    within '.companies-table' do
      companies.each do |company|
        expect(page).to have_content company.id
        expect(page).to have_content company.name
      end
    end
  end

  scenario 'Visitor can filter companies' do
    Company.elasticsearch_reindex
    sleep 2
    visit companies_path
    fill_in('companies-search', with: companies[0].name)
    find('#companies-search').native.send_keys(:return)
    within '.companies-table' do
      expect(page).not_to have_content companies[1].name
      expect(page).to have_content companies[0].name
    end
  end
end