# frozen_string_literal: true
# == Schema Information
#
# Table name: work_set_types
#
#  id              :integer          not null, primary key
#  name            :string
#  count_as_one    :boolean
#  appraise_as_one :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  hide            :boolean
#

class WorkSetType < ApplicationRecord
  include NameId
  include Hidable
end
