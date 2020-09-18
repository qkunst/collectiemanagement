require "action_view"

module Builders
  class NokogiriBuilder
    class_attribute :default_format
    self.default_format = "application/xml"

    def call(template)
      require "nokogiri"
      "xml = ::Nokogiri::XML::Builder.new { |xml|" +
        template.source +
        "}.to_xml;"
    end
  end
end
