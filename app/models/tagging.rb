# == Schema Information
#
# Table name: taggings
#
#  id            :integer          not null, primary key
#  tag_id        :integer
#  taggable_type :string
#  taggable_id   :integer
#  tagger_type   :string
#  tagger_id     :integer
#  context       :string(128)
#  created_at    :datetime
#
# Indexes
#
#  index_taggings_on_context                                    (context)
#  index_taggings_on_tag_id                                     (tag_id)
#  index_taggings_on_taggable_id                                (taggable_id)
#  index_taggings_on_taggable_id_and_taggable_type_and_context  (taggable_id,taggable_type,context)
#  index_taggings_on_taggable_type                              (taggable_type)
#  index_taggings_on_tagger_id                                  (tagger_id)
#  index_taggings_on_tagger_id_and_tagger_type                  (tagger_id,tagger_type)
#  taggings_idx                                                 (tag_id,taggable_id,taggable_type,context,tagger_id,tagger_type) UNIQUE
#  taggings_idy                                                 (taggable_id,taggable_type,tagger_id,context)
#

class Tagging < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :tag
end
