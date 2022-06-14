# == Schema Information
#
# Table name: contacts
#
#  id            :bigint           not null, primary key
#  address       :text
#  external      :boolean
#  name          :string
#  remote_data   :text
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :bigint
#
class Contact < ApplicationRecord
  belongs_to :collection

  validates_presence_of :name
  validates_presence_of :url, if: :external_and_no_remote_data?
  validates_uniqueness_of :url, if: :external_and_no_remote_data?, scope: :collection

  scope :internal, ->{ where(external: [nil, false]) }
  scope :external, ->{ where(external: true) }
  scope :without_url, ->{ where(url: nil)}

  has_many :time_spans

  def name
    read_attribute(:name) || (external? ? "External" : nil)
  end

  def to_s
    "#{name} (#{url})"
  end

  def external_and_no_remote_data?
    external? && remote_data.blank?
  end

  def to_select_value
    external_and_no_remote_data? ? Uitleen::Customer.new(uri: url) : self
  end
end
