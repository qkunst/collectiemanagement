# frozen_string_literal: true

# == Schema Information
#
# Table name: cached_apis
#
#  id         :integer          not null, primary key
#  query      :string
#  response   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CachedApi < ApplicationRecord
  before_save :pull_url!

  scope :expired, -> { where(arel_table[:created_at].lt(Time.now - 1.month)) }

  def pull_url!
    require "open-uri"
    self.response = URI.open(query).read # standard:disable Security/Open is only used for known urls
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
