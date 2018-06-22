class CustomReportTemplate < ApplicationRecord
  include Template

  belongs_to :collection, optional: true

  validates_presence_of :title

  alias_attribute :name, :title
  alias_attribute :contents, :text


end
