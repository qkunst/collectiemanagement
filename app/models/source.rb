# frozen_string_literal: true

# == Schema Information
#
# Table name: sources
#
#  id         :bigint           not null, primary key
#  hide       :boolean          default(FALSE)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Source < ApplicationRecord
  scope :not_hidden, -> { where(hide: [nil, false]) }
  include NameId
end
