class MakeAppraisalsNotWorkSpecific < ActiveRecord::Migration[6.0]
  def change
    rename_column :appraisals, :work_id, :appraisee_id
    add_column :appraisals, :appraisee_type, :string, default: "Work"
  end
end