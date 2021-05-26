# frozen_string_literal: true

class AddNoticeToAppraisals < ActiveRecord::Migration[6.0]
  def change
    add_column :appraisals, :notice, :text
    add_column :works, :appraisal_notice, :text
    add_column :work_sets, :appraisal_notice, :text
  end
end
