console.log("batch coffee");

document.addDelegatedEventListener('batchinput:change', '#batch-work input, #batch-work textarea, #batch-work select', function(e) {
  var cluster_selector, cluster_selector_text_value, strategyElement;
  strategyElement = document.getElementById(e.target.dataset.strategyInputId);
  if (strategyElement && strategyElement.value === "IGNORE") {
    strategyElement.value = "REPLACE";
  }
  if (e.target.id === "work_cluster_name") {
    cluster_selector = document.getElementById("work_cluster_id");
    cluster_selector_text_value = document.querySelector(`#work_cluster_id option[value='${cluster_selector.value}']`).text;
    console.log(cluster_selector_text_value);
    console.log(e.target.value);
    if (cluster_selector_text_value !== e.target.value) {
      cluster_selector.value = null;
      return cluster_selector.dispatchEvent(new Event('chosen:updated'));
    }
  }
});

document.addDelegatedEventListener('batchinput:change:cluster', '#batch-work select', function(e) {
  var name_target;
  name_target = document.getElementById("work_cluster_name");
  if (e.target.value) {
    name_target.value = document.querySelector(`#work_cluster_id option[value='${e.target.value}']`).text;
    return name_target.dispatchEvent(new Event('batchinput:change', {
      bubbles: true
    }));
  }
});
