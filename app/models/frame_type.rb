# frozen_string_literal: true

# == Schema Information
#
# Table name: frame_types
#
#  id         :bigint           not null, primary key
#  hide       :boolean
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class FrameType < ApplicationRecord
  include Hidable
  include NameId
end
