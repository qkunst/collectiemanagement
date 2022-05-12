# frozen_string_literal: true

# == Schema Information
#
# Table name: work_set_types
#
#  id              :bigint           not null, primary key
#  appraise_as_one :boolean
#  count_as_one    :boolean
#  hide            :boolean
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "rails_helper"

RSpec.describe WorkSetType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
