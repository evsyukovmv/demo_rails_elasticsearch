require 'rails_helper'

feature 'Offers list', js: true do
  let!(:offers) { FactoryGirl.create_list(:offer, 2) }

  scenario 'Visitor can see all offers on the page' do
    visit root_path
    within '.offers-table' do
      offers.each do |offer|
        expect(page).to have_content offer.id
        expect(page).to have_content offer.title
      end
    end
  end

  scenario 'Visitor can filter offers' do
    Offer.elasticsearch_reindex
    sleep 2
    visit root_path
    fill_in('offers-search', with: offers[0].title)
    find('#offers-search').native.send_keys(:return)
    within '.offers-table' do
      expect(page).not_to have_content offers[1].title
      expect(page).not_to have_content offers[1].id
      expect(page).to have_content offers[0].title
      expect(page).to have_content offers[0].id
    end
  end
end