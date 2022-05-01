# frozen_string_literal: true

module BatchHelper
  # def batch_updatable_input
end

class SimpleForm::FormBuilder
  def batch_editable_strategy_select param_name
    select(object.class.strategy_attribute_for(param_name), object.class.strategies_for(param_name).collect { |a| [I18n.t(a, scope: "helpers.batch.strategies"), a] })
  end

  def batch_editable_input name, options = {}
    param_name = options.delete(:param_name) || name
    input_type = options.delete(:input_type) || :input

    model_name_prefix = lookup_model_names.join("_")
    model_name_prefix = model_name_prefix == "work_appraisals" ? "work_appraisals_attributes_0" : model_name_prefix

    options = options.deep_merge(input_html: {data: {strategy_input_id: "#{model_name_prefix}_#{object.class.strategy_attribute_for(param_name)}"}})

    spacer_div = options[:as] == :boolean ? "<div></div>" : ""
    [send(input_type, name, options), spacer_div, batch_editable_strategy_select(param_name)].join("\n").html_safe
  end
end
