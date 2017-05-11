require 'elasticsearch/model'

class Offer < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :title, :customer, presence: true
  belongs_to :customer

  after_touch() { __elasticsearch__.index_document }

  def as_indexed_json(_options = {})
    title_suggest = {
      title_suggest: {
        input: [title, description, customer.name, customer.company.name]
      }
    }

    all = as_json(
      include: {
        customer: {
          methods: :name, only: :name, include: { company: { only: :name } }
        }
      }
    ).merge(title_suggest)
    all
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :title, analyzer: 'english'
      indexes :description, analyzer: 'english'
      indexes :customer do 
        indexes :name, analyzer: 'english'
        indexes :company do 
          indexes :name, analyzer: 'english'
        end
      end
      indexes :title_suggest, type: 'completion'
    end
  end

  def self.suggest query
    __elasticsearch__.client.suggest(:index => index_name, :body => {
      :suggestions => {
        :text => query,
        :completion => {
          :field => 'title_suggest'
        }
      }
    })
  end
end

Offer.__elasticsearch__.client.indices.delete index: Offer.index_name rescue nil

Offer.__elasticsearch__.client.indices.create \
  index: Offer.index_name,
  body: { settings: Offer.settings.to_hash, mappings: Offer.mappings.to_hash }

Offer.includes(customer: :company).import