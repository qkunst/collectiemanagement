class CustomReportTemplate < ApplicationRecord
  belongs_to :collection, optional: true

  validates_presence_of :title

  alias_attribute :name, :title
end
