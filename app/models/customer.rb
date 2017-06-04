require 'elasticsearch/model'

class Customer < ApplicationRecord
  include Elasticsearch::Model
  include Searchable

  validates :first_name, :last_name, :company, presence: true
  belongs_to :company
  has_many :offers

  default_scope { includes(:company).order(id: :desc) }

  def name
    "#{first_name} #{last_name}"
  end

  def name_with_company
    "#{first_name} #{last_name} - #{company.name}"
  end

  def as_indexed_json(_options = {})
    suggest_fields = {
      suggest_fields: {
        input: [first_name, last_name, company.name]
      }
    }

    fields = as_json(
      include: { company: { only: :name } }, only: [:first_name, :last_name]
    ).merge(suggest_fields)
    fields
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :first_name, analyzer: 'english'
      indexes :last_name, analyzer: 'english'
      indexes :company do
        indexes :name, analyzer: 'english'
      end
      indexes :suggest_fields, type: 'completion'
    end
  end

  def touch_dependencies
    offers.find_each(&:touch)
  end
end
