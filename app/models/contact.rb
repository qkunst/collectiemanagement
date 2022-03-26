class Contact < ApplicationRecord
  belongs_to :collection

  validates_presence_of :name
  validates_presence_of :url, if: :external?
  validates_uniqueness_of :url, if: :external?

  has_many :time_spans

  def name
    read_attribute(:name) || (external? ? "External" : nil)
  end

  def to_s
    "#{name} (#{url})"
  end
end
