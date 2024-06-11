# frozen_string_literal: true

Lockbox.master_key = Rails.application.credentials.secret_key_base[1..64]
