# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    after_commit on: [:create] do
      index_async!
    end

    after_commit on: [:update] do
      reindex_async! # if self.published?
    end

    before_commit on: [:destroy] do
      __elasticsearch__.delete_document
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      # document already deleted :)
    end

    after_touch do
      reindex_async!
    end

    def index_async!
      if is_a? Work
        IndexWorkWorker.perform_async(id)
      else
        reindex!
      end
    end

    def reindex_async!
      if is_a? Work
        ReindexWorkWorker.perform_async(id)
      else
        reindex!
      end
    end

    def reindex!
      __elasticsearch__.update_document
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      __elasticsearch__.index_document
    rescue Faraday::ConnectionFailed
      # don't complain; it's search
    end
  end

  class_methods do
    def reindex!(recreate_index = false)
      if recreate_index
        __elasticsearch__.create_index! force: true
        __elasticsearch__.refresh_index!
      end
      find_each do |a|
        a.reindex!
      end
    end

    def reindex_async!
      all.each(&:reindex_async!)
    end
  end
end
