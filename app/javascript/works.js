// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
var Selection, click_thumb_event, disable_group_selections, show_offline_stored_count_message, show_or_hide_selected_works, show_screen_image;

show_or_hide_selected_works = function() {
  var checked_group_selector, i, len, select_all_scope, select_all_scopes, selected_works_count, tekst;
  selected_works_count = 0;
  select_all_scopes = document.querySelectorAll("#works-list .select_all_scope");
  if (select_all_scopes.length === 0) {
    select_all_scopes = [document.getElementById("works-list")].filter(function(elem) {
      return elem;
    });
  }
  for (i = 0, len = select_all_scopes.length; i < len; i++) {
    select_all_scope = select_all_scopes[i];
    checked_group_selector = select_all_scope.querySelector("input[name^='selected_work_groups']:checked");
    if (checked_group_selector) {
      selected_works_count += parseInt(checked_group_selector.dataset.workCount);
    } else {
      selected_works_count += select_all_scope.querySelectorAll("input[type=checkbox]:checked").length;
    }
  }
  if (selected_works_count > 0) {
    tekst = selected_works_count === 1 ? "Batch acties beschikbaar voor één geselecteerd onderdeel" : `Batch acties beschikbaar voor ${selected_works_count} geselecteerde onderdelen`;
    $("#selected-works-count").html(tekst);
    return $("#selected-works").show();
  } else {
    return $("#selected-works").hide();
  }
};

disable_group_selections = function(e) {
  var selection;
  selection = new Selection($(e.target).parents(".select_all_scope, body")[0]);
  return selection.disableGroupSelect();
};

show_screen_image = function(e) {
  return document.location = e.target.src.replace('screen_', '');
};

show_offline_stored_count_message = function() {
  var messageContainer, offline_stored_count;
  messageContainer = document.getElementById("offline-works-message");
  if (messageContainer) {
    offline_stored_count = FormStore.Store.count_by_key_start(document.location.toString().split("/works")[0] + "/works");
    if (offline_stored_count > 0) {
      messageContainer.classList.remove("hide");
      return messageContainer.innerText = "Er zijn " + offline_stored_count + " werk(en) nog niet gesynchroniseerd met de server, zodra de server terug online is worden deze opnieuw geprobeerd";
    } else {
      return messageContainer.classList.add("hide");
    }
  }
};

click_thumb_event = function(e) {
  var image_url, show_area;
  image_url = $(e.currentTarget).attr("href");
  if ($(e.currentTarget).find("img").length > 0) {
    show_area = $(e.target).closest(".imageviewer").find("img.show");
    show_area.attr("src", image_url);
    show_area.click(show_screen_image);
    return false;
  }
};

$(document).on("change", ".work.panel input[type=checkbox], #batch_edit_property", function(e) {
  disable_group_selections(e);
  return show_or_hide_selected_works(e);
});

$(document).on("click", "img.show", show_screen_image);

$(document).on("click", ".imageviewer .thumbs a", click_thumb_event);

$(document).on("submit", "form#new_work", function() {
  var d, lastLocation, lastLocationFloor;
  d = new Date();
  d.setHours(24);
  lastLocation = $("form#new_work input#work_location").val();
  docCookies.setItem("lastLocation", lastLocation, d);
  lastLocationFloor = $("form#new_work input#work_location_floor").val();
  return docCookies.setItem("lastLocationFloor", lastLocationFloor, d);
});

window.addEventListener("load", function(event) {
  show_offline_stored_count_message();
  show_or_hide_selected_works();
  setTimeout(function() {
    return show_or_hide_selected_works();
  }, 500);
  $("form#new_work input#work_location").val(docCookies.getItem("lastLocation"));
  return $("form#new_work input#work_location_floor").val(docCookies.getItem("lastLocationFloor"));
});

document.addEventListener("turbo:load", function(event) {
  $("form#new_work input#work_location").val(docCookies.getItem("lastLocation"));
  $("form#new_work input#work_location_floor").val(docCookies.getItem("lastLocationFloor"));
  show_or_hide_selected_works();
  return show_offline_stored_count_message();
});

$(document).on("keydown", "input[data-catch-return]", function(e) {
  if (e.originalEvent.code === "Enter") {
    return false;
  } else {
    return true;
  }
});

Selection = class Selection {
  constructor(container) {
    this.container = container;
  }

  groupInputs() {
    return this.container.querySelectorAll("input[name^='selected_work_groups[']");
  }

  inputs() {
    return this.container.querySelectorAll("input[name='selected_works[]']");
  }

  _changeStatus(elements, status) {
    var elem, i, inputs, len;
    inputs = elements;
    for (i = 0, len = inputs.length; i < len; i++) {
      elem = inputs[i];
      elem.checked = status;
    }
    return show_or_hide_selected_works();
  }

  disableGroupSelect() {
    var buttons, elem, i, len;
    this._changeStatus(this.groupInputs(), false);
    buttons = this.container.querySelectorAll("button.unselect_all");
    for (i = 0, len = buttons.length; i < len; i++) {
      elem = buttons[i];
      elem.classList.add("select_all");
      elem.classList.remove("unselect_all");
      elem.innerHTML = "Selecteer alles";
    }
    elem = document.getElementById("global-select-button");
    elem.classList.add("select_all");
    elem.classList.remove("unselect_all");
    return elem.innerHTML = "Selecteer alles";
  }

  unselectAll() {
    this._changeStatus(this.inputs(), false);
    return this.disableGroupSelect();
  }

  selectAll() {
    var buttons, elem, i, len, results;
    this._changeStatus(this.inputs(), true);
    this._changeStatus(this.groupInputs(), true);
    buttons = this.container.querySelectorAll("button.select_all");
    results = [];
    for (i = 0, len = buttons.length; i < len; i++) {
      elem = buttons[i];
      elem.classList.add("unselect_all");
      elem.classList.remove("select_all");
      results.push(elem.innerHTML = "Deselecteer alles");
    }
    return results;
  }

};

$(document).on("click", "button.select_all", function(e) {
  var selection;
  selection = new Selection($(e.target).parents(".select_all_scope, body")[0]);
  return selection.selectAll();
});

$(document).on("click", "button.unselect_all", function(e) {
  var selection;
  selection = new Selection($(e.target).parents(".select_all_scope, body")[0]);
  return selection.unselectAll();
});
