# rails g model cached_api query response:text

class CachedApi < ApplicationRecord
  before_save :pull_url!

  def pull_url!
    require 'open-uri'
    self.response = open(self.query).read
  end

  def json
    JSON.parse(self.response)
  end

  class << self
    def query(url)
      CachedApi.find_or_create_by({query: url}).json
    end
  end
end
