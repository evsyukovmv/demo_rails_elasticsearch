require 'rails_helper'

RSpec.describe Offer, type: :model do
  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:customer) }
  end

  context 'associations' do
    it { should belong_to(:customer) }
  end

  context 'elasticsearch' do
    let(:offers) { FactoryGirl.create_list(:offer, 2) }

    before(:each) do
      offers
      Offer.create_indicies_and_import
      sleep 2
    end

    it 'should search by fields' do
      [
        'title',
        'customer.first_name',
        'customer.company.name'
      ].each do |field|
        offer = offers.sample
        search = Offer.search(offer.instance_eval(field))
        expect(search.records.size).to eql 1
        expect(search.records[0]).to eql offer
      end
    end

    it 'should return suggestions' do
      offer = offers.sample
      suggestions = Offer.suggest(
        offer.customer.company.name
      )['suggestions'][0]['options']
      expect(suggestions.size).to eql 1
      expect(suggestions[0]['text']).to eql offer.customer.company.name
      expect(suggestions[0]['_id']).to eql offer.id.to_s
    end
  end
end
