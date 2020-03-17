# frozen_string_literal: true

# rails g model cached_api query response:text

class CachedApi < ApplicationRecord
  before_save :pull_url!

  scope :expired, -> { where(arel_table[:created_at].lt(Time.now - 1.month)) }

  def pull_url!
    require "open-uri"
    self.response = open(query).read
  end

  def json
    JSON.parse(response)
  end

  class << self
    def query(url)
      CachedApi.find_or_create_by({query: url}).json
    end

    def purge
      expired.delete_all
    end
  end
end
