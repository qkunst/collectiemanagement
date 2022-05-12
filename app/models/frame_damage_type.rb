# frozen_string_literal: true

# == Schema Information
#
# Table name: frame_damage_types
#
#  id         :bigint           not null, primary key
#  hide       :boolean          default(FALSE)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class FrameDamageType < ApplicationRecord
  include Hidable
  include NameId
end
