# == Schema Information
#
# Table name: contacts
#
#  id            :bigint           not null, primary key
#  address       :text
#  external      :boolean
#  name          :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :bigint
#
class Contact < ApplicationRecord
  belongs_to :collection

  validates_presence_of :name
  validates_presence_of :url, if: :external?
  validates_uniqueness_of :url, if: :external?, scope: :collection

  scope :internal, ->{ where(external: [nil, false]) }
  scope :external, ->{ where(external: true) }

  has_many :time_spans

  def name
    read_attribute(:name) || (external? ? "External" : nil)
  end

  def to_s
    "#{name} (#{url})"
  end
end
