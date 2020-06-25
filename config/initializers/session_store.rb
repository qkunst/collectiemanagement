# frozen_string_literal: true

# Be sure to restart your server when you modify this file.


if Rails.env.production?
  Rails.application.config.session_store :active_record_store, key: '__Host-collectiemanagement_session', same_site: :strict, secure: true
else
  Rails.application.config.session_store :active_record_store, key: 'collectiemanagement_session'
end