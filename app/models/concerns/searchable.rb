module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    after_commit on: [:create] do
      begin
        __elasticsearch__.index_document
      rescue Faraday::ConnectionFailed
        sleep(3)
        __elasticsearch__.index_document
      end
    end

    after_commit on: [:update] do
      self.reindex! #if self.published?
    end

    after_commit on: [:destroy] do
      begin
        __elasticsearch__.delete_document
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        # document already deleted :)
      end
    end

    after_touch do
      reindex!
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