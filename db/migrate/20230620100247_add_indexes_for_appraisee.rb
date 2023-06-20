class AddIndexesForAppraisee < ActiveRecord::Migration[7.0]
  def change
    add_index :appraisals, [:appraisee_id, :appraisee_type], unique: false
    add_index :time_spans, [:subject_type, :subject_id], unique: false
  end
end
