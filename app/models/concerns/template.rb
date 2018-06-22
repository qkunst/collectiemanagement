# adds the following methods:
#
# #contents_as_html
# #content_merge(variables={}) #pass key value pairs
# #fields # unique list of fields inside the template (without modifiers)

module Template
  extend ActiveSupport::Concern

  included do
    def contents_as_html
      if contents.to_s.match(/[*\n]/)
        Kramdown::Document.new(contents.to_s).to_html
      else
        contents.to_s
      end
    end

    def content_merge variables = {}
      variables.stringify_keys!
      new_contents = contents_as_html
      Template::Helper.fields_with_modifiers(contents).each do | field_mod |
        field = field_mod[:field]
        mods = field_mod[:mods]
        value = Template::Helper.apply_mods(variables[field].to_s, mods)
        regex = /\{\{\s*#{[field, mods].flatten.join(".")}\s*\}\}/
        new_contents.gsub!(regex, value)
      end
      Template::Helper.object_calls_with_modifiers(contents).each do | object_call_mod |
        objekt = object_call_mod[:object]
        method = object_call_mod[:method]
        mods = object_call_mod[:mods]
        value = Template::Helper.do_object_call(objekt, method).to_s
        value = Template::Helper.apply_mods(value, mods)
        regex = /\{\{\s*#{[objekt, method, mods].flatten.join(".")}\s*\}\}/
        new_contents.gsub!(regex, value)
      end
      new_contents
    end

    def fields
      Template::Helper.fields_with_modifiers(contents).collect{|a| a[:field]}.uniq
    end

  end

  class Helper
    class << self
      def object_calls_with_modifiers contents
        rv = []
        contents.to_s.scan(/\{\{\s*([A-Z]+[a-z\_\.\d]*)\s*\}\}/).flatten.each do |field_with_mod|
          field_with_mod_split = field_with_mod.split(".")
          objekt = field_with_mod_split.delete_at(0)
          method = field_with_mod_split.delete_at(0)
          rv << {object: objekt, method: method, mods: field_with_mod_split}
        end
        rv
      end

      def fields_with_modifiers contents
        rv = []
        contents.to_s.scan(/\{\{\s*([a-z\_\.\d]*)\s*\}\}/).flatten.each do |field_with_mod|
          field_with_mod_split = field_with_mod.split(".")
          field = field_with_mod_split.delete_at(0)
          rv << {field: field, mods: field_with_mod_split }
        end
        rv
      end

      def apply_mod string, mod
        case mod.to_sym
        when :hoofdletter, :hoofdletter_start
          string.capitalize!
        when :hoofdletters
          string.upcase!
        when :aanhef
          string = string.downcase.gsub("de heer","de").strip
        when :verkort
          test_string = string.downcase
          if test_string == "de heer"
            string = "Dhr."
          elsif test_string == "mevrouw"
            string = "Mevr."
          end
        end
        string
      end

      def apply_mods string, mods
        mods.each do |mod|
          string = apply_mod(string, mod)
        end
        string
      end

      def do_object_call object, call
        case object.to_s.downcase.to_sym
        when :datum
          Template::Helper::LetterTextAreaObjects::Datum.send(call.to_sym) if Template::Helper::LetterTextAreaObjects::Datum.methods.include?(call.to_sym)
        end
      end
    end
    module LetterTextAreaObjects
      class Datum
        def self.vandaag
          I18n.l Time.now.to_date, format: :long
        end
      end
    end
  end
end


