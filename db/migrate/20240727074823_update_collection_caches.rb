class UpdateCollectionCaches < ActiveRecord::Migration[7.1]
  def change
    # removed methods; this migration led to problems, when running from scratch there is nothing to update anyway.
  end
end
