import "./controllers"
const $ = require("jquery");
window.$ = $;
window.jQuery = $;

const UJS = require("rails-ujs");
import * as Turbo from "@hotwired/turbo"

UJS.start();

// import Foundation from 'foundation-sites';
//import "controllers"
import('./prototypes');

require('jquery_nested_form');
require('chosen-js');
require('select2')(this, $);

import('./context_container');
import('./cookie');
import('./debug');
import('./filter-list');
import('./forms');
import('./batch');
import('./report');
import('./table_filterable');
import('./table_sortable');
import('./works');
import('./offline_collections')
import('./block_link');
require('./toggle');

const FormStore = require('./formstore.js').default;
window.FormStore = FormStore;

import { Application } from 'stimulus'
import Chart from '@stimulus-components/chartjs'

const application = Application.start()
application.register('chart', Chart)


var collectieBeheerInit = function () {
  FormStore.init();

  function formatRepo(result) {
    if (result.loading || !result.name) return result.text;

    var markup = "<div class='select2-result clearfix'><strong>" +
      result.name +
      "</strong> <small>" +
      result.desc +
      "</small></div>";

    return markup;
  }

  $(".select2").select2().on('select2:select', function (e) {
    var $selectedElement = $(e.params.data.element);
    var $selectedElementOptgroup = $selectedElement.parent("optgroup");

    if ($selectedElementOptgroup.length > 0) {
      $selectedElement.data("select2-originaloptgroup", $selectedElementOptgroup);
    }

    $selectedElement.detach().appendTo($(e.target));
    $(e.target).trigger('change');
  }).on('select2:unselect', function (e) {

  });


  $(".select2.geoname-select").select2({
    placeholder: "Type een lokaliteit...",
    language: {
      // You can find all of the options in the language files provided in the
      // build. They all must be functions that return the string that should be
      // displayed.
      inputTooShort: function () { return "Begin met zoeken door te typen..." },
      searching: function () { return "Bezig met zoeken..." }
    },
    allowClear: true,
    ajax: {
      url: "/geoname_summaries.json",
      dataType: 'json',
      delay: 250,
      transport: function (params, success, failure) {
        fetch(params.url).then(function (response) {
          return response.json();
        }).then(function (response) {
          return success(response);
        }).catch(function (error) {
          return failure(error);
        });
      },
      data: function (params) {
        return {
          // q: params.term, // search term
          // page: params.page
        };
      },
      processResults: function (data, params) {
        var subset = [];

        var regex_start = RegExp("^" + params.term, 'i');
        var regex_middle = RegExp(params.term, 'i');

        for (var dat in data) {
          dat = data[dat]
          if (subset.length > 30) break;
          if (dat.name.match(regex_start)) subset.push(dat);
        }

        return {
          results: subset
        };
      },
      cache: true
    },
    escapeMarkup: function (markup) { return markup; },
    minimumInputLength: 1,
    templateResult: formatRepo,
    templateSelection: formatRepo
  });

  $(".select2.tags").select2({
    placeholder: "Voer tags in...",
    language: {
      // You can find all of the options in the language files provided in the
      // build. They all must be functions that return the string that should be
      // displayed.
      inputTooShort: function () { return "Begin met zoeken door te typen..." },
      searching: function () { return "Bezig met zoeken..." }
    },
    allowClear: true,
    ajax: {
      url: "/tags.json",
      dataType: 'json',
      delay: 250,
      cache: true
    },
    minimumInputLength: 1
  });

  $(".select2.location").select2({
    placeholder: "Type een lokaliteit...",
    tags: true
  })

  $(".chosen-select").chosen({
    placeholder_text_single: "Selecteer een optie",
    placeholder_text_multiple: "Type de opties",
    no_results_text: "Geen optie gevonden",
    allow_single_deselect: true
  })

  $(".tabs section").hide();
  $(".tabs section").first().show();
  $(".tabs ul li a").first().addClass("selected");

  let windowWidthInEM = window.innerWidth / parseFloat(
    getComputedStyle(
      document.querySelector('body')
    )['font-size']
  )
}

window.collectieBeheerInit = collectieBeheerInit;

$(document).on('click touch', ".tabs ul li a", function (e) {
  $(".tabs ul li a").removeClass("selected");
  $(".tabs section").hide();

  var anchor = $(e.target).attr("href");
  $(e.target).addClass("selected");
  $(".tabs section" + anchor).show();
  return false;
});


$(document).on("change", "form[data-auto-submit=true] input[data-auto-submit=true], form[data-auto-submit=true] select[data-auto-submit=true]", function (event) {
  var form = $(event.target).parents("form[data-auto-submit=true]");
  if (form[0].method == 'get') {
    var action = form.attr("action");
    var url = action + (action.indexOf('?') == -1 ? '?' : '&') + form.serialize();
    window.Turbo.visit(url);
    return false;
  } else if (form[0].method == 'post') {
    // ignore for now
  }
})

$(document).on("click keydown touch", "button[method=post]", function (e) {
  var form = $(e.target).parents("form[data-auto-submit=true]");
  form.attr("method", "post")
});

$(document).on("click touch", ".collapsable li", function (e) {
  var $target = $(e.target);
  if ($target.hasClass("expanded")) {
    setTimeout(function (e) {
      $target.removeClass("expanded");
    }, 100);
  } else {
    setTimeout(function (e) {
      $target.addClass("expanded");
    }, 100);
  }

});

if (window.isSecureContext) {
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/sw.js', { scope: '/' })
      .then(function (reg) {
        // registration worked
        console.log('Registration succeeded. Scope is ' + reg.scope);
      }).catch(function (error) {
        // registration failed
        console.log('Registration failed with ', error);
      });
  }
} else {
  console.log('Not in secure context')
}

$(document).ready(function () {
  collectieBeheerInit()
})

$(document).on("turbo:load", function () {
  collectieBeheerInit()
})

console.log("application.js loaded")