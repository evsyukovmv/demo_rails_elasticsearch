module Searchable
  extend ActiveSupport::Concern

  def touch_dependencies
  end

  included do
    after_touch do 
      __elasticsearch__.index_document
      touch_dependencies
    end

    after_commit on: [:create, :update] do
      __elasticsearch__.index_document
      touch_dependencies
    end

    after_commit on: [:destroy] do
      __elasticsearch__.delete_document
      touch_dependencies
    end

    def self.suggest(query)
      __elasticsearch__.client.suggest(
        index: index_name,
        body: {
          suggestions: {
            text: query,
            completion: { field: 'suggest_fields' }
          }
        }
      )
    end

    def self.elasticsearch_reindex
      delete_indicies rescue nil
      create_indicies
      import
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
end