# frozen_string_literal: true

# == Schema Information
#
# Table name: owners
#
#  id              :bigint           not null, primary key
#  creating_artist :boolean          default(FALSE)
#  description     :text
#  hide            :boolean          default(FALSE)
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  collection_id   :bigint
#
class Owner < ApplicationRecord
  include CollectionOwnable
  include Hidable
  include NameId

  has_many :works
  belongs_to :collection, optional: false
end
