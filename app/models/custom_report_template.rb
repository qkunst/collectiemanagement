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
class CustomReportTemplate < ApplicationRecord
  include Hidable
  include Template

  belongs_to :collection, optional: true

  has_many :custom_reports

  validates_presence_of :title

  alias_attribute :name, :title
  alias_attribute :contents, :text
end
