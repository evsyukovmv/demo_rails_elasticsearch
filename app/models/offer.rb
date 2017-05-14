require 'elasticsearch/model'

class Offer < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :title, :customer, presence: true
  belongs_to :customer

  after_touch() { __elasticsearch__.index_document }

  def as_indexed_json(_options = {})
    fields_suggest = {
      fields_suggest: {
        input: [title, description, customer.name, customer.company.name]
      }
    }

    all = as_json(
      include: {
        customer: {
          methods: :name, only: :name, include: { company: { only: :name } }
        }
      }
    ).merge(fields_suggest)
    all
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :title, analyzer: 'english'
      indexes :customer do
        indexes :name, analyzer: 'english'
        indexes :description, analyzer: 'english'
        indexes :company do
          indexes :name, analyzer: 'english'
        end
      end
      indexes :fields_suggest, type: 'completion'
    end
  end

  def self.suggest(query)
    __elasticsearch__.client.suggest(
      index: index_name,
      body: {
        suggestions: {
          text: query,
          completion: { field: 'fields_suggest' }
        }
      }
    )
  end

  def self.elasticsearch_reindex
    delete_index
    create_indicies
    includes(customer: :company).import
  end

  def self.delete_indicies
    __elasticsearch__.client.indices.delete index: index_name
  end

  def self.create_indicies
    __elasticsearch__.client.indices.create \
      index: index_name,
      body: { settings: settings.to_hash, mappings: mappings.to_hash }
  end
end
