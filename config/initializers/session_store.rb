# frozen_string_literal: true

Rails.application.config.session_store :cookie_store, expire_after: 2.days, same_site: (Rails.env.development? || Rails.env.test?) ? :lax : :none, secure: (Rails.env.development? || Rails.env.test?) ? false : true