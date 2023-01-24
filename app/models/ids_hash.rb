# == Schema Information
#
# Table name: ids_hashes
#
#  id             :bigint           not null, primary key
#  hashed         :string           not null
#  ids_compressed :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_ids_hashes_on_hashed  (hashed) UNIQUE
#
class IdsHash < ApplicationRecord
  after_initialize :store_hash
  validates_presence_of :hashed, :ids_compressed


  class << self
    def init(*args)
      ids = args.flatten

      string = to_ranges(ids).join(",")
      compressed_string = Zlib::Deflate.deflate(string)
      base_64_compressed_string = Base64.encode64(compressed_string)

      self.new(ids_compressed: base_64_compressed_string.strip)
    end

    def store(*args)
      rv = self.init(args)
      existing = IdsHash.find_by_hashed(rv.hashed)

      if existing && (existing.ids_compressed == rv.ids_compressed)
        existing
      else
        rv.save
        rv
      end
    end

    def to_ranges(ids)
      ids = ids.sort
      prev = ids[0]
      ids.slice_before { |e|
        prev, prev2 = e, prev
        prev2 + 1 != e
      }.map{|b,*,c| c ? (b..c) : b }
    end
  end

  def ids
    Zlib::Inflate.inflate(Base64.decode64(ids_compressed)).split(",").map do |part|
      split_parts = part.split("..").map(&:to_i)
      split_parts.length == 2 ? Range.new(*split_parts) : split_parts.first
    end
  end

  private

  def store_hash
    digest = Digest::SHA2.new
    digest << ids_compressed
    self.hashed = digest.to_s
  end

end
