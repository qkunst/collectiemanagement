# frozen_string_literal: true

# == Schema Information
#
# Table name: balance_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  hide       :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BalanceCategory < ApplicationRecord
  include Hidable
  include NameId
end
