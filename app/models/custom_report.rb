# frozen_string_literal: true
# == Schema Information
#
# Table name: custom_reports
#
#  id                        :integer          not null, primary key
#  custom_report_template_id :integer
#  title                     :string
#  variables                 :string
#  html_cache                :string
#  collection_id             :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class CustomReport < ApplicationRecord
  belongs_to :collection
  belongs_to :custom_report_template
  has_and_belongs_to_many :works

  validates_presence_of :collection, :custom_report_template

  store :variables

  def template_fields
    custom_report_template.fields
  end

  def title
    tmp = read_attribute(:title)
    if tmp.nil? || (tmp == "")
      [custom_report_template.name, I18n.l(created_at.to_date, format: :long)].join(", ")
    else
      tmp
    end
  end
  alias_method :name, :title

  def title_with_collection
    [collection.name, title].compact.join(": ")
  end

  def merged_content
    custom_report_template.content_merge(variables)
  end
end
