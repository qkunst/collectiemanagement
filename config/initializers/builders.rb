require "#{Rails.root}/app/builders/nokogiri_builder"
ActionView::Template.register_template_handler :nokogiri, Builders::NokogiriBuilder.new