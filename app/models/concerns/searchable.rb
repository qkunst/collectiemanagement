# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    after_commit on: [:create] do
      self.index_async!
    end

    after_commit on: [:update] do
      self.reindex_async! #if self.published?
    end

    before_commit on: [:destroy] do
      begin
        __elasticsearch__.delete_document
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        # document already deleted :)
      end
    end

    after_touch do
      self.reindex_async!
    end

    def index_async!
      if self.is_a? Work
        IndexWorkWorker.perform_async(self.id)
      else
        reindex!
      end
    end

    def reindex_async!
      if self.is_a? Work
        ReindexWorkWorker.perform_async(self.id)
      else
        reindex!
      end
    end

    def reindex!
      begin
        __elasticsearch__.update_document
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        __elasticsearch__.index_document
      rescue Faraday::ConnectionFailed
        # don't complain; it's search
      end
    end

  end

  class_methods do
    def reindex!(recreate_index=false)
      seconds_to_sleep = recreate_index ? 0 : 1
      if recreate_index
        self.__elasticsearch__.create_index! force: true
        self.__elasticsearch__.refresh_index!
      end
      self.find_each{|a| a.reindex!; sleep(seconds_to_sleep)}
    end
  end
end
