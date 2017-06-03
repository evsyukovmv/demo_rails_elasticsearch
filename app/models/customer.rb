class Customer < ApplicationRecord
  include Elasticsearch::Model

  validates :first_name, :last_name, :company, presence: true
  belongs_to :company
  has_many :offers

  after_touch do
     __elasticsearch__.index_document
     offers.find_each(&:touch)
  end

  after_commit on: [:create] do
    __elasticsearch__.index_document
    offers.find_each(&:touch)
  end

  after_commit on: [:update] do
    __elasticsearch__.index_document
    offers.find_each(&:touch)
  end

  after_commit on: [:destroy] do
    __elasticsearch__.delete_document
    offers.find_each(&:touch)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name_with_company
    "#{first_name} #{last_name} - #{company.name}"
  end

  def as_indexed_json(_options = {})
    as_json \
      include: { company: { only: :name } }, only: [:first_name, :last_name]
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :first_name, analyzer: 'english'
      indexes :last_name, analyzer: 'english'
      indexes :company do
        indexes :name, analyzer: 'english'
      end
    end
  end

  def self.elasticsearch_reindex
    delete_indicies rescue nil
    create_indicies
    includes(:company).import
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
