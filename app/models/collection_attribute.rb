# frozen_string_literal: true

# == Schema Information
#
# Table name: collection_attributes
#
#  id               :bigint           not null, primary key
#  attribute_type   :string           default("unknown")
#  attributed_type  :string
#  label            :string
#  language         :string
#  value_ciphertext :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  attributed_id    :bigint
#  collection_id    :bigint
#
class CollectionAttribute < ApplicationRecord
  LANGUAGES = %w[nl en not_applicable].freeze
  ATTRIBUTE_TYPES = %w[email telephone_number website description public_description unknown].freeze
  LOCALIZED_ATTRIBUTE_TYPES = %w[description public_description].freeze
  MULTI_LINE_INPUTS = %w[description public_description].freeze

  has_encrypted :value
  has_paper_trail

  belongs_to :collection
  belongs_to :attributed, polymorphic: true

  before_validation :set_defaults_when_missing

  validates_uniqueness_of :label, scope: [:collection_id, :attributed_id, :attributed_type]
  validates_presence_of :label, :value, :collection, :attributed
  validates :language, inclusion: {in: LANGUAGES}
  validates :attribute_type, inclusion: {in: ATTRIBUTE_TYPES}

  scope :for_collection, ->(collections) { where(collection: collections.is_a?(Collection) ? collections.expand_with_child_collections : collections) }
  scope :for_user, ->(user) { for_collection(user.accessible_collections) }
  scope :description, -> { where(attribute_type: :description) }
  scope :public_description, -> { where(attribute_type: :public_description) }
  scope :language, ->(language) { where(language: language) }

  after_save :touch_relations

  def collection= collection
    self.collection_id = collection.base_collection.id
  end

  def input_type
    MULTI_LINE_INPUTS.include?(attribute_type) ? :text : :string
  end
  alias_method :output_type, :input_type

  def label
    read_attribute(:label) || I18n.t("activerecord.values.collection_attributes.attribute_type.#{attribute_type}.#{language}")
  end

  private

  def set_defaults_when_missing
    self.attribute_type ||= "unknown"
    self.language ||= LOCALIZED_ATTRIBUTE_TYPES.include?(attribute_type) ? :nl : :not_applicable
  end

  def touch_relations
    if attributed.is_a?(Artist)
      attributed.touch
      attributed.works.update_all(significantly_updated_at: Time.current, updated_at: Time.current)
    elsif attributed.is_a?(Work)
      attributed.update_columns(significantly_updated_at: Time.current, updated_at: Time.current)
    end
  end
end
