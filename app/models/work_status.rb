# frozen_string_literal: true

class WorkStatus < ApplicationRecord
  include Hidable
  include NameId

  has_and_belongs_to_many :works
end
