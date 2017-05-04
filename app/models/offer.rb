require 'elasticsearch/model'

class Offer < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :title, :customer, presence: true
  belongs_to :customer

  after_touch() { __elasticsearch__.index_document }

  def as_indexed_json(_options = {})
    as_json(
      include: {
        customer: {
          only: %i[first_name last_name], include: { company: { only: :name } }
        }
      }
    )
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :title, analyzer: 'english'
      indexes :description, analyzer: 'english'
      indexes :customer do 
        indexes :first_name, analyzer: 'english'
        indexes :last_name, analyzer: 'english'
        indexes :company do 
          indexes :name, analyzer: 'english'
        end
      end
    end
  end
end

Offer.__elasticsearch__.client.indices.delete index: Offer.index_name rescue nil

Offer.__elasticsearch__.client.indices.create \
  index: Offer.index_name,
  body: { settings: Offer.settings.to_hash, mappings: Offer.mappings.to_hash }

Offer.import
