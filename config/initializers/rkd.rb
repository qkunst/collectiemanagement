RKD::Config.file_cache_enabled = true
class RKD::Artist
  def to_param
    identifier
  end
end
