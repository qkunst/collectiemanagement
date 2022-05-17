# frozen_string_literal: true

# == Schema Information
#
# Table name: work_statuses
#
#  id                                  :bigint           not null, primary key
#  hide                                :boolean          default(FALSE)
#  name                                :string
#  set_work_as_removed_from_collection :boolean
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#
class WorkStatus < ApplicationRecord
  include Hidable
  include NameId

  has_and_belongs_to_many :works
end
