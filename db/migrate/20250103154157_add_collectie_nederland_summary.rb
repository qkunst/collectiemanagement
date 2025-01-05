class AddCollectieNederlandSummary < ActiveRecord::Migration[7.2]
  def change
    add_column(:artists, :collectie_nederland_summary, :jsonb, default: {})
  end
end
