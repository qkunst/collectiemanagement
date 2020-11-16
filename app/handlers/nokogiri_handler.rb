require "action_view"
require "nokogiri"

class NokogiriHandler
  class_attribute :default_format
  self.default_format = "application/xml"

  def call(template, source)
    "xml = ::Nokogiri::XML::Builder.new { |xml|" +
      source +
      "}.to_xml;"
  end
end
