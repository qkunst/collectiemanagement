# frozen_string_literal: true

class Theme < ApplicationRecord
  include NameId, Hidable, CollectionOwnable
end
