# frozen_string_literal: true

require "#{Rails.root}/app/handlers/nokogiri_handler"
require "#{Rails.root}/app/handlers/markdown_handler"

ActionView::Template.register_template_handler :nokogiri, NokogiriHandler.new
ActionView::Template.register_template_handler :md, MarkdownHandler.new
