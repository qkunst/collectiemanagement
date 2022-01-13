class Contact < ApplicationRecord
  belongs_to :collection

  validates_presence_of :name
  validates_presence_of :url, if: :external?

  def name
    read_attribute(:name) || (external? ? "External" : nil)
  end
end
