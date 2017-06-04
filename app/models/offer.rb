require 'elasticsearch/model'

class Offer < ApplicationRecord
  include Elasticsearch::Model
  include Searchable

  validates :title, :customer, presence: true
  belongs_to :customer

  default_scope { includes(customer: :company).order(id: :desc) }

  def as_indexed_json(_options = {})
    suggest_fields = {
      suggest_fields: {
        input: [title, description, customer.name, customer.company.name]
      }
    }

    fields = as_json(
      include: {
        customer: {
          methods: :name, only: :name, include: { company: { only: :name } }
        }
      }
    ).merge(suggest_fields)
    fields
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
      indexes :suggest_fields, type: 'completion'
    end
  end
end
