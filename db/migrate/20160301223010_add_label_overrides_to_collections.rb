# frozen_string_literal: true

class AddLabelOverridesToCollections < ActiveRecord::Migration[4.2]
  def change
    add_column :collections, :label_override_work_alt_number_1, :string
    add_column :collections, :label_override_work_alt_number_2, :string
    add_column :collections, :label_override_work_alt_number_3, :string
  end
end
