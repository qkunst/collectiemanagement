# frozen_string_literal: true

class CustomReportTemplate < ApplicationRecord
  include Hidable
  include Template

  belongs_to :collection, optional: true

  has_many :custom_reports

  validates_presence_of :title

  alias_attribute :name, :title
  alias_attribute :contents, :text
end
