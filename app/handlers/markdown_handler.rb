require 'kramdown'

class MarkdownHandler
  def erb
    @erb ||= ActionView::Template.registered_template_handler(:erb)
  end

  def call(template, source)
    compiled_source = erb.call(template, source)
    "sanitize Kramdown::Document.new(string, input: :markdown).to_html"
  end
end
