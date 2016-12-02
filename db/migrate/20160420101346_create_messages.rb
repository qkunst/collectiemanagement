class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :in_reply_to_message_id
      t.boolean :qkunst_private
      t.integer :conversation_start_message_id
      t.string :subject
      t.text :message
      t.text :subject_url
      t.boolean :just_a_note
      t.string :image
      t.datetime :actioned_upon_by_qkunst_admin_at
      t.string :subject_object_type
      t.integer :subject_object_id

      t.timestamps null: false
    end
  end
end
