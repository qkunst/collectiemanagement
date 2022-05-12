# frozen_string_literal: true

# == Schema Information
#
# Table name: import_collections
#
#  id                  :bigint           not null, primary key
#  file                :string
#  import_file_snippet :text
#  settings            :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  collection_id       :bigint
#
require "rails_helper"

RSpec.describe ImportCollection, type: :model do
  describe "instance methods" do
    describe "#name" do
      it "should return a name even when no file has been uploaded" do
        i = ImportCollection.new
        expect(i.name).to eq("Geen bestand geüpload")
      end
    end
  end
end
