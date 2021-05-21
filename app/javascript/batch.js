// document.addDelegatedEventListener('batchinput:change', '#batch-work input, #batch-work textarea, #batch-work select', function(e) {
// doesnt' seem to work here, somehow jQuery's delegated even listening is smarter / better / stronger / especially with e.g. select2 events

$(document).on('change', '#batch-work input[data-strategy-input-id], #batch-work textarea[data-strategy-input-id], #batch-work select[data-strategy-input-id]', function(e) {
  console.log("change", e);
  var cluster_selector, cluster_selector_text_value, strategyElement;
  strategyElement = document.getElementById(e.target.dataset.strategyInputId);
  if (strategyElement && strategyElement.value === "IGNORE") {
    if (strategyElement.id === "work_update_tag_list_strategy" ) {
      strategyElement.value = "APPEND";
    } else {
      strategyElement.value = "REPLACE";
    }
  }
  if (e.target.id === "work_cluster_name") {
    cluster_selector = document.getElementById("work_cluster_id");
    cluster_selector_text_value = document.querySelector(`#work_cluster_id option[value='${cluster_selector.value}']`).text;
    console.log(cluster_selector_text_value);
    console.log(e.target.value);
    if (cluster_selector_text_value !== e.target.value) {
      cluster_selector.value = null;
      return $(cluster_selector).trigger('change.select2');
    }
  }
});

$(document).on('change', '#work_cluster_id', function(e) {
  var name_target;
  name_target = document.getElementById("work_cluster_name");
  if (e.target.value) {
    name_target.value = document.querySelector(`#work_cluster_id option[value='${e.target.value}']`).text;
    return $(name_target).trigger('change')
  }
})
