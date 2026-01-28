# frozen_string_literal: true
# == Schema Information
#
# Table name: custom_report_templates
#
#  id            :integer          not null, primary key
#  title         :string
#  text          :text
#  collection_id :integer
#  work_fields   :text
#  hide          :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe CustomReportTemplate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
