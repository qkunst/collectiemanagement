# frozen_string_literal: true

# == Schema Information
#
# Table name: themes
#
#  id            :bigint           not null, primary key
#  hide          :boolean          default(FALSE)
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :bigint
#
class Theme < ApplicationRecord
  include CollectionOwnable
  include Hidable
  include NameId

  has_and_belongs_to_many :works
end
