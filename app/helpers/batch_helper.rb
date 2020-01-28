module BatchHelper
  # def batch_updatable_input
end

class SimpleForm::FormBuilder
  def batch_editable_strategy_select param_name
    select(BatchWorkForm::strategy_attribute_for(param_name), BatchWorkForm.strategies_for(param_name))
  end
  def batch_editable_input name, options = {}
    param_name = options.delete(:param_name) || name
    input_type = options.delete(:input_type) || :input

    model_name_prefix = lookup_model_names.join("_")
    model_name_prefix = model_name_prefix == "work_appraisals" ? "work_appraisals_attributes_0" : model_name_prefix


    options = options.deep_merge(input_html: {onchange: "this.dispatchEvent(new Event('batchinput:change', {bubbles: true}))", data: {strategy_input_id: "#{model_name_prefix}_#{BatchWorkForm::strategy_attribute_for(param_name)}"}})
    [self.send(input_type, name, options), batch_editable_strategy_select(param_name)].join("\n").html_safe
  end

end