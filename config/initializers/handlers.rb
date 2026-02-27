# frozen_string_literal: true

require Rails.root.join("app/handlers/nokogiri_handler").to_s

ActionView::Template.register_template_handler :nokogiri, NokogiriHandler.new
