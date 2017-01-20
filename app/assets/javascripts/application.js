// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//  require jquery.turbolinks
//= require foundation
//= require chosen
//= require fetch
//= require select2
//= require jquery_nested_form
//= require_directory .

var collectieBeheerInit = function() {
  FormStore.init();

  function formatRepo (result) {
    if (result.loading || !result.name) return result.text;

    var markup = "<div class='select2-result clearfix'><strong>" +
      result.name +
      "</strong> <small>" +
      result.desc +
      "</small></div>";

    return markup;
  }

  $(".select2").select2().on('select2:select', function(e){
    $selectedElement = $(e.params.data.element);
    $selectedElementOptgroup = $selectedElement.parent("optgroup");
    if ($selectedElementOptgroup.length > 0) {
      $selectedElement.data("select2-originaloptgroup", $selectedElementOptgroup);
    }
    $selectedElement.detach().appendTo($(e.target));
    $(e.target).trigger('change');
  }).on('select2:unselect', function(e){

  });


  $(".select2.ajax").select2({
    placeholder: "Type een lokaliteit...",
    language: {
      // You can find all of the options in the language files provided in the
      // build. They all must be functions that return the string that should be
      // displayed.
      inputTooShort: function() {return "Begin met zoeken door te typen..." },
      searching: function() { return "Bezig met zoeken..."}
    },
    allowClear: true,
    ajax: {
      url: "/geoname_summaries.json",
      dataType: 'json',
      delay: 250,
      transport: function (params, success, failure) {
        fetch(params.url).then(function(response) {
          return response.json();
        }).then(function(response) {
          return success(response);
        }).catch(function(error) {
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

        var regex_start = RegExp("^"+params.term, 'i');
        var regex_middle = RegExp(params.term, 'i');

        for (var dat in data) {
          dat = data[dat]
          if (subset.length > 30) break;
          if (dat.name.match(regex_start)) subset.push(dat);
        }
        for (var dat in data) {
          dat = data[dat]
          if (subset.length > 30) break;
          if (dat.name.match(regex_middle) && subset.indexOf(dat) === -1) subset.push(dat);
        }
        for (var dat in data) {
          dat = data[dat]
          if (subset.length > 30) break;
          if (dat.desc.match(regex_start) && subset.indexOf(dat) === -1) subset.push(dat);
        }
        for (var dat in data) {
          dat = data[dat]
          if (subset.length > 30) break;
          if (dat.desc.match(regex_middle) && subset.indexOf(dat) === -1) subset.push(dat);
        }

        // params.page = params.page || 1;

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

  $(".chosen-select").chosen({
    placeholder_text_single: "Selecteer een optie",
    placeholder_text_multiple: "Type de opties",
    no_results_text: "Geen optie gevonden",
    allow_single_deselect: true,
  })



  $(".tabs section").hide();
  $(".tabs section").first().show();
  $(".tabs ul li a").first().addClass("selected");
  $(".tabs ul li a").click(function(e) {
    $(".tabs ul li a").removeClass("selected");
    $(".tabs section").hide();

    var anchor = $(e.target).attr("href");
    $(e.target).addClass("selected");
    $(".tabs section"+anchor).show();
    return false;
  });


  $(document).foundation();
}

$(document).on("change", "form[data-auto-submit=true] input[data-auto-submit=true], form[data-auto-submit=true] select[data-auto-submit=true]", function(event) {
  var form = $(event.target).parents("form[data-auto-submit=true]");
  var action = form.attr("action");
  var url = action+(action.indexOf('?') == -1 ? '?' : '&')+form.serialize();
  Turbolinks.visit(url);
  return false;
})

$(document).on("click keydown", "button[method=post]", function(e) {
  var form = $(e.target).parents("form[data-auto-submit=true]");
  form.attr("method","post")
});

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js', {scope: '/'})
  .then(function(reg) {
    // registration worked
    console.log('Registration succeeded. Scope is ' + reg.scope);
  }).catch(function(error) {
    // registration failed
    console.log('Registration failed with ' + error);
  });
}

// f = FormStore.Form.parseForm(document.forms[0])
// f.submitForm()

$(document).ready(function(){
  collectieBeheerInit()
})

$(document).on("turbolinks:load", function(){
  collectieBeheerInit()
})