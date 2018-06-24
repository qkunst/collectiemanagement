# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

show_or_hide_selected_works = ->
  selected_works_count = $(".work.panel input[type=checkbox]:checked").length
  if selected_works_count > 0
    $("#selected-works-count").html(selected_works_count)
    $("#selected-works").show()
  else
    $("#selected-works").hide()

show_screen_image = (e)->
  document.location = e.target.src.replace('screen_','')

click_thumb_event = (e)->
  image_url = $(e.currentTarget).attr("href")
  if $(e.currentTarget).find("img").length > 0
    show_area = $(e.target).closest(".imageviewer").find("img.show")
    show_area.attr("src",image_url)
    show_area.click(show_screen_image)
    return false

$(document).on("change",".work.panel input[type=checkbox], #batch_edit_property", ->
  show_or_hide_selected_works()
)
$(document).on("click","img.show",show_screen_image)
$(document).on("click",".imageviewer .thumbs a", click_thumb_event)
$(document).on("submit","form#new_work", ->
  d = new Date()
  d.setHours(24)
  lastLocation = $("form#new_work input#work_location").val();
  docCookies.setItem("lastLocation", lastLocation, d)
)

$(document).on("ready", ->
  show_or_hide_selected_works()
  setTimeout(->
    show_or_hide_selected_works()
  , 500)
  $("form#new_work input#work_location").val(docCookies.getItem("lastLocation"))
)
$(document).on("turbolinks:load", ->
  $("form#new_work input#work_location").val(docCookies.getItem("lastLocation"))
  show_or_hide_selected_works()
)

$(document).on "keydown", "input[data-catch-return]", (e)->
  if e.originalEvent.code == "Enter"
    return false
  else
    return true

$(document).on("click", "span.select_all", (e)->
  container_div = $(e.target).parents(".select_all_scope, body")[0]
  inputs = container_div.querySelectorAll("input[name='selected_works[]']")
  for elem in inputs
    elem.checked = true
  $(inputs[0]).trigger('change')
  e.target.classList.add "unselect_all"
  e.target.classList.remove "select_all"
  e.target.innerHTML = "Deselecteer alles"
  buttons = container_div.querySelectorAll("span.select_all")
  for elem in buttons
    elem.classList.add "unselect_all"
    elem.classList.remove "select_all"
    elem.innerHTML = "Deselecteer alles"
)

$(document).on("click", "span.unselect_all", (e)->
  container_div = $(e.target).parents(".select_all_scope, body")[0]
  inputs = container_div.querySelectorAll("input[name='selected_works[]']")
  for elem in inputs
    elem.checked = false
  $(inputs[0]).trigger('change')
  e.target.classList.add "select_all"
  e.target.classList.remove "unselect_all"
  e.target.innerHTML = "Selecteer alles"
  buttons = container_div.querySelectorAll("span.unselect_all")
  for elem in buttons
    elem.classList.add "select_all"
    elem.classList.remove "unselect_all"
    elem.innerHTML = "Selecteer alles"
)