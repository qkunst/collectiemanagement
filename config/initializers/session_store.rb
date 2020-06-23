# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :active_record_store, key: '__Host-collectiemanagement_session', same_site: :strict, secure: Rails.env.production?