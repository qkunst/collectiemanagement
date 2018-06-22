class CustomReport < ApplicationRecord
  belongs_to :collection
  belongs_to :custom_report_template
  has_and_belongs_to_many :works

  validates_presence_of :collection
  validates_presence_of :custom_report_template

  store :variables

  def template_fields
    custom_report_template.fields
  end

  def merged_content
    custom_report_template.content_merge(variables)
  end
end
