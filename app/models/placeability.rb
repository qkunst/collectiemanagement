# frozen_string_literal: true

# == Schema Information
#
# Table name: placeabilities
#
#  id         :bigint           not null, primary key
#  hide       :boolean          default(FALSE)
#  name       :string
#  order      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Placeability < ApplicationRecord
  has_many :works
  scope :not_hidden, -> { where(hide: [nil, false]) }

  include NameId
end
