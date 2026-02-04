# frozen_string_literal: true

# == Schema Information
#
# Table name: library_items
#
#  id            :integer          not null, primary key
#  item_type     :string
#  collection_id :integer
#  title         :string
#  author        :string
#  ean           :string
#  stock_number  :string
#  location      :string
#  description   :text
#  thumbnail     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe LibraryItem, type: :model do
end
