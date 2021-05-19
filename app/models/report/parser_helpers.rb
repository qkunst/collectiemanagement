# frozen_string_literal: true

module Report
  module ParserHelpers
    IGNORE_KEYS = ["key", "doc_count", "total"]
    attr_accessor :base_report

    def parse_bucket bucket
      subcounts_in_hash = {}
      bucket.each do |subkey, subset|
        sub_counts = parse_aggregation(subset, subkey)
        subkey = subkey.gsub(/_missing$/, "")
        if sub_counts.present?
          if subcounts_in_hash[subkey.to_sym]
            subcounts_in_hash[subkey.to_sym].deep_merge! sub_counts
          else
            subcounts_in_hash[subkey.to_sym] = sub_counts
          end
        end
      end
      subcounts_in_hash
    end

    def parse_aggregation aggregation, aggregation_key
      counts = {}
      if aggregation.is_a?(Hash) && aggregation[:doc_count] && aggregation_key.to_s.match(/^.*_missing$/) && (aggregation.keys - IGNORE_KEYS).count == 0
        counts[:missing] = {count: (base_report ? 0 : aggregation[:doc_count]), subs: {}}
      elsif aggregation.is_a?(Hash) && aggregation[:buckets]
        buckets = aggregation.buckets
        buckets.each do |bucket|
          subcounts_in_hash = parse_bucket(bucket)

          key = parse_bucket_key(aggregation_key, bucket["key"])

          key_model = key_model_relations[aggregation_key]
          if key_model
            key = key_model.send(:names, key)
          end

          counts[key] = {count: (base_report ? 0 : bucket.doc_count), subs: subcounts_in_hash}
        end
      elsif aggregation.is_a?(Hash) && (aggregation.keys - IGNORE_KEYS).count > 0 && !IGNORE_KEYS.include?(aggregation_key)
        subcounts_in_hash = parse_bucket aggregation

        if /^.*_missing$/.match?(aggregation_key.to_s)
          aggregation_key = :missing
        end

        counts[aggregation_key] = {count: (base_report ? 0 : aggregation.doc_count), subs: subcounts_in_hash}
      end
      return counts unless IGNORE_KEYS.include?(aggregation_key)
    end

    def parse_bucket_key aggregation_key, bucket_key
      bucket_key_parsed = bucket_key

      unless ["abstract_or_figurative", "object_format_code", "grade_within_collection", "location_raw", "location_floor_raw", "location_detail_raw", "tag_list"].include?(aggregation_key)
        bucket_key_parsed = bucket_key.to_s.split(",").map(&:to_i)
      end
      bucket_key_parsed
    end
  end
end
