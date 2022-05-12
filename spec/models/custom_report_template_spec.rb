# frozen_string_literal: true

# == Schema Information
#
# Table name: custom_report_templates
#
#  id            :bigint           not null, primary key
#  hide          :boolean
#  text          :text
#  title         :string
#  work_fields   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :bigint
#
require "rails_helper"

RSpec.describe CustomReportTemplate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
