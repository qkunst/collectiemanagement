class AddConfirmationTokenconfirmedAtconfirmationSentAtunconfirmedEmailToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    User.update_all(confirmed_at: "2000-01-01T00:00".to_datetime)
  end
end
