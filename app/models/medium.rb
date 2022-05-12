# frozen_string_literal: true

# == Schema Information
#
# Table name: media
#
#  id         :bigint           not null, primary key
#  hide       :boolean          default(FALSE)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Medium < ApplicationRecord
  include Hidable
  include NameId
end
