# frozen_string_literal: true

require "#{Rails.root}/app/handlers/nokogiri_handler"

ActionView::Template.register_template_handler :nokogiri, NokogiriHandler.new
