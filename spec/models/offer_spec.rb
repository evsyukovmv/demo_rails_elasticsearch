require 'rails_helper'

RSpec.describe Offer, type: :model do
  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:customer) }
  end

  context 'associations' do
    it { should belong_to(:customer) }
  end

  context 'search' do
    let!(:offers) { FactoryGirl.create_list(:offer, 2) }
    let!(:offer) { offers.sample }

    before(:each) do
      Offer.__elasticsearch__.client.indices.flush
    end

    it 'should search by title' do
      search = Offer.search(offer.title)
      expect(search.records.size).to eql 1
      expect(search.records[0]).to eql offer
    end

    it 'should search by description' do
      search = Offer.search(offer.description)
      expect(search.records.size).to eql 1
      expect(search.records[0]).to eql offer
    end

    it 'should search by customer name' do
      search = Offer.search(offer.customer.first_name)
      expect(search.records.size).to eql 1
      expect(search.records[0]).to eql offer
    end

    it 'should search by company name' do
      search = Offer.search(offer.customer.company.name)
      expect(search.records.size).to eql 1
      expect(search.records[0]).to eql offer
    end
  end

  context 'suggest' do
    let!(:offers) { FactoryGirl.create_list(:offer, 2) }
    let!(:offer) { offers.sample }

    before(:each) do
      Offer.__elasticsearch__.client.indices.flush
    end

    it 'should return suggestions' do
      suggestions = Offer.suggest(
        offer.customer.company.name
      )['suggestions'][0]['options']
      expect(suggestions.size).to eql 1
      expect(suggestions[0]['text']).to eql offer.customer.company.name
      expect(suggestions[0]['_id']).to eql offer.id.to_s
    end
  end
end
