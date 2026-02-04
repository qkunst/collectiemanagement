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

class CustomReportTemplate < ApplicationRecord
  include Hidable
  include Template

  belongs_to :collection, optional: true

  has_many :custom_reports

  validates_presence_of :title

  alias_attribute :name, :title
  alias_attribute :contents, :text
end
