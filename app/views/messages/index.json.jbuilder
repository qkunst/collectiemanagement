# frozen_string_literal: true

json.array!(@messages) do |message|
  json.extract! message, :id, :from_user_id, :to_user_id, :in_reply_to_message_id, :qkunst_private, :conversation_start_message_id, :subject, :message, :subject_url, :just_a_note, :image
  json.url message_url(message, format: :json)
end
