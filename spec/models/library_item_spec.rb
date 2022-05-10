# frozen_string_literal: true

# == Schema Information
#
# Table name: library_items
#
#  id            :bigint           not null, primary key
#  author        :string
#  description   :text
#  ean           :string
#  item_type     :string
#  location      :string
#  stock_number  :string
#  thumbnail     :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :bigint
#
require "rails_helper"

RSpec.describe LibraryItem, type: :model do
end
