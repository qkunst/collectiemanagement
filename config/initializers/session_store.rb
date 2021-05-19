# frozen_string_literal: true

running_locally = Rails.env.development? || Rails.env.test?

Rails.application.config.session_store :cookie_store, expire_after: 2.days, same_site: running_locally ? :lax : :none, secure: running_locally ? false : true
