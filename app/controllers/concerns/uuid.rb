# frozen_string_literal: true

module Uuid
  extend ActiveSupport::Concern
  included do
    validates_presence_of :uuid
    before_validation :set_uuid

    private

    def set_uuid
      self.uuid ||= SecureRandom.uuid
    end
  end

end
