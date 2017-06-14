module Report
  module ParserHelpers
    def parse_aggregation aggregation, aggregation_key
      counts = {}
      # raise aggregation
      if aggregation.is_a? Hash and aggregation[:doc_count] and aggregation_key.to_s.match(/^.*\_missing$/)
        counts[:missing] = {count: aggregation[:doc_count], subs: {}}
      elsif aggregation.is_a? Hash and aggregation[:buckets]
        buckets = aggregation.buckets #.sort{|a,b| a[:key]<=>b[:key]}
        # raise buckets
        buckets.each do |bucket|
          subcounts_in_hash = {}
          bucket.each do |subkey, subset|
            sub_counts = parse_aggregation(subset,subkey)
            subkey = subkey.gsub(/_missing$/,"")
            if sub_counts
              if subcounts_in_hash[subkey.to_sym]
                subcounts_in_hash[subkey.to_sym].deep_merge! sub_counts
              else
                subcounts_in_hash[subkey.to_sym] = sub_counts
              end
            end
          end
          key = parse_bucket_key(aggregation_key,bucket["key"])

          key_model = self.key_model_relations[aggregation_key]
          if key_model
            key = key_model.send(:names, key)
          end

          counts[key] = {count: bucket.doc_count, subs: subcounts_in_hash }
        end
      end
      return counts unless ["key","doc_count", "total"].include?(aggregation_key)
    end

    def parse_bucket_key aggregation_key, bucket_key
      bucket_key_parsed = bucket_key

      unless ["abstract_or_figurative.keyword", "object_format_code.keyword", "grade_within_collection.keyword", "location_raw.keyword", "location_floor_raw.keyword", "location_detail_raw.keyword"].include?(aggregation_key)
        bucket_key_parsed = bucket_key.to_s.split(",").map(&:to_i)
      end
      return bucket_key_parsed
    end
  end
end