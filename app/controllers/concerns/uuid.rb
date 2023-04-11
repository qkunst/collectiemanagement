# frozen_string_literal: true

module Uuid
  extend ActiveSupport::Concern
  included do
    before_validation :set_uuid
    validates_presence_of :uuid
    validates_uniqueness_of :uuid

    alias_attribute :external_id, :uuid

    private

    def set_uuid
      self.uuid ||= SecureRandom.uuid
    end
  end
end
