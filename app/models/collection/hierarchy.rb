# frozen_string_literal: true

module Collection::Hierarchy
  extend ActiveSupport::Concern

  included do
    scope :not_root, -> { where.not(root: true) }
    scope :root_collections, ->{ where(root: true) }
    scope :with_root_parent, ->{ where(parent_collection: Collection.unscoped.root_collections) }

    def possible_parent_collections(options={})
      Collection.for_user_expanded(options[:user]).all + Collection.root_collections - self.expand_with_child_collections
    end

    def parent_collections_flattened
      self_and_parent_collections_flattened.where.not(id: self.id)
    end

    def self_and_parent_collections_flattened
      expand_with_parent_collections.not_system
    end

    def expand_with_child_collections
      self.id ? Collection.where("id IN (SELECT CAST(branch_split AS INTEGER) FROM (select regexp_split_to_table(branch,'~') AS branch_split
  from connectby('collections', 'id', 'parent_collection_id', '#{self.id}', 0, '~')
  as (id int, pid int, lvl int, branch text)) AS branches)") : Collection.none
    end

    def child_collections_flattened
      expand_with_child_collections.where.not(id: self.id)
    end

    def expand_with_parent_collections
      self.id ? Collection.unscope(:order).joins("INNER JOIN (
        SELECT CAST(regexp_split_to_table(branch,'~') AS INTEGER) AS branch_split, branch
          FROM connectby('collections', 'id', 'parent_collection_id', '#{Collection.unscoped.root_collection.id}', 0, '~') as (id int, pid int, lvl int, branch text)
          WHERE id = #{self.id}
        ) AS collection_branche_ids ON collections.id = collection_branche_ids.branch_split") : Collection.none
    end
  end

  class_methods do
    def root_collection
      ::Collection.root_collections.first
    end

    def expand_with_child_collections(depth = 5)
      raise ArgumentError, "depth can't be < 1" if depth < 1
      join_sql = "LEFT OUTER JOIN collections c1_cs ON collections.id = c1_cs.parent_collection_id "
      select_sql = "collections.id AS _child_level0, c1_cs.id AS _child_level1"
      depth -= 1 # we already have depth = 1
      depth.times do |dept|
        join_sql += "LEFT OUTER JOIN collections c#{(2+dept).to_i}_cs ON c#{(1+dept).to_i}_cs.id = c#{(2+dept).to_i}_cs.parent_collection_id "
        select_sql += ", c#{(2+dept).to_i}_cs.id AS _child_level#{(2+dept).to_i}"
      end
      ids = []
      self.
        joins(join_sql).
        select(select_sql).
        each do | intermediate_result |
          (depth + 1).times { |a| ids << intermediate_result.send("_child_level#{a}".to_sym) }
        end
      ::Collection.unscoped.where(id: ids.compact.uniq)
    end

  end
end