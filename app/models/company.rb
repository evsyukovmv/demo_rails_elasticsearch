require 'elasticsearch/model'

class Company < ApplicationRecord
  include Elasticsearch::Model
  include Searchable

  validates_presence_of :name
  has_many :customers

  default_scope { order(id: :desc) }

  def as_indexed_json(_options = {})
    suggest_fields = { suggest_fields: { input: [name, address] } }
    fields = as_json(only: [:name, :address]).merge(suggest_fields)
    fields
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name, analyzer: 'english'
      indexes :address, analyzer: 'english'
      indexes :suggest_fields, type: 'completion'
    end
  end

  def touch_dependencies
    customers.find_each(&:touch)
  end
end
