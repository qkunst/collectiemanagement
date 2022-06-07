# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

show_or_hide_selected_works = ->
  selected_works_count = 0

  select_all_scopes = document.querySelectorAll("#works-list .select_all_scope")

  if select_all_scopes.length == 0
    select_all_scopes = [document.getElementById("works-list")].filter((elem)->elem)

  for select_all_scope in select_all_scopes
    checked_group_selector = select_all_scope.querySelector "input[name^='selected_work_groups']:checked"

    if checked_group_selector
      selected_works_count += parseInt checked_group_selector.dataset.workCount
    else
      selected_works_count += select_all_scope.querySelectorAll("input[type=checkbox]:checked").length

  if selected_works_count > 0
    tekst = if selected_works_count == 1
        "Batch acties beschikbaar voor één geselecteerd onderdeel"
      else
        "Batch acties beschikbaar voor #{selected_works_count} geselecteerde onderdelen"

    $("#selected-works-count").html(tekst)
    $("#selected-works").show()
  else
    $("#selected-works").hide()

disable_group_selections = (e)->
  selection = new Selection($(e.target).parents(".select_all_scope, body")[0])
  selection.disableGroupSelect()


show_screen_image = (e)->
  document.location = e.target.src.replace('screen_','')

show_offline_stored_count_message = ->
  messageContainer = document.getElementById("offline-works-message")
  if messageContainer
    offline_stored_count = (FormStore.Store.count_by_key_start(document.location.toString().split("/works")[0]+"/works"));
    if (offline_stored_count > 0)
      messageContainer.classList.remove("hide")

      messageContainer.innerText = "Er zijn "+offline_stored_count+" werk(en) nog niet gesynchroniseerd met de server, zodra de server terug online is worden deze opnieuw geprobeerd"
    else
      messageContainer.classList.add("hide")

click_thumb_event = (e)->
  image_url = $(e.currentTarget).attr("href")
  if $(e.currentTarget).find("img").length > 0
    show_area = $(e.target).closest(".imageviewer").find("img.show")
    show_area.attr("src",image_url)
    show_area.click(show_screen_image)
    return false

$(document).on("change",".work.panel input[type=checkbox], #batch_edit_property", (e)->
  disable_group_selections(e)
  show_or_hide_selected_works(e)
)

$(document).on("click","img.show",show_screen_image)
$(document).on("click",".imageviewer .thumbs a", click_thumb_event)
$(document).on("submit","form#new_work", ->
  d = new Date()
  d.setHours(24)
  lastLocation = $("form#new_work input#work_location").val();
  docCookies.setItem("lastLocation", lastLocation, d)
  lastLocationFloor = $("form#new_work input#work_location_floor").val();
  docCookies.setItem("lastLocationFloor", lastLocationFloor, d)
)

window.addEventListener "load", (event)->
  show_offline_stored_count_message()
  show_or_hide_selected_works()
  setTimeout(->
    show_or_hide_selected_works()
  , 500)
  $("form#new_work input#work_location").val(docCookies.getItem("lastLocation"))
  $("form#new_work input#work_location_floor").val(docCookies.getItem("lastLocationFloor"))


document.addEventListener "turbolinks:load", (event)->
  $("form#new_work input#work_location").val(docCookies.getItem("lastLocation"))
  $("form#new_work input#work_location_floor").val(docCookies.getItem("lastLocationFloor"))
  show_or_hide_selected_works()
  show_offline_stored_count_message()


$(document).on "keydown", "input[data-catch-return]", (e)->
  if e.originalEvent.code == "Enter"
    return false
  else
    return true

class Selection
  constructor: (@container)->

  groupInputs: ()->
    @container.querySelectorAll("input[name^='selected_work_groups[']")

  inputs: ()->
    @container.querySelectorAll("input[name='selected_works[]']")

  _changeStatus: (elements, status)->
    inputs =elements
    for elem in inputs
      elem.checked = status
    show_or_hide_selected_works()

  disableGroupSelect: ()->
    @_changeStatus(@groupInputs(), false)

    buttons = @container.querySelectorAll("button.unselect_all")
    for elem in buttons
      elem.classList.add "select_all"
      elem.classList.remove "unselect_all"
      elem.innerHTML = "Selecteer alles"

    elem = document.getElementById("global-select-button")
    elem.classList.add "select_all"
    elem.classList.remove "unselect_all"
    elem.innerHTML = "Selecteer alles"

  unselectAll: ()->
    @_changeStatus(@inputs(), false)
    @disableGroupSelect()

  selectAll: ()->
    @_changeStatus(@inputs(), true)
    @_changeStatus(@groupInputs(), true)

    buttons = @container.querySelectorAll("button.select_all")
    for elem in buttons
      elem.classList.add "unselect_all"
      elem.classList.remove "select_all"
      elem.innerHTML = "Deselecteer alles"


$(document).on("click", "button.select_all", (e)->
  selection = new Selection($(e.target).parents(".select_all_scope, body")[0])
  selection.selectAll()
)

$(document).on("click", "button.unselect_all", (e)->
  selection = new Selection($(e.target).parents(".select_all_scope, body")[0])
  selection.unselectAll()
)




