ELEMENTS_QUERY = "noscript[data-lazy=\"lazy-load\"]"

decodeEntities = (encodedString)->
  # required for IE and Safari
  textArea = document.createElement('textarea')
  textArea.innerHTML = encodedString
  textArea.value

lazy_load_image_in_noscript_wrapper = (noscript_tag)->
  fragment = noscript_tag.innerHTML
  parent = noscript_tag.parentElement
  parent.innerHTML = decodeEntities(fragment)

process_intersection_observer_entry = (entry)->
  if entry.intersectionRatio > 0
    noscript_tag = entry.target.querySelector("noscript")
    if noscript_tag
      lazy_load_image_in_noscript_wrapper noscript_tag

lazy_load_images = ->
  noscript_wrapped_images = document.querySelectorAll(ELEMENTS_QUERY)
  supportsIntersectionObserver = typeof IntersectionObserver == "function"
  if supportsIntersectionObserver
    intersectionObsOptions =
      root_margin: "100px"
    intersectionObserver = new IntersectionObserver((entries)->
      entries.forEach(process_intersection_observer_entry)
    , intersectionObsOptions)
    noscript_wrapped_images.forEach((e)->intersectionObserver.observe(e.parentElement))
  else
    noscript_wrapped_images.forEach(lazy_load_image_in_noscript_wrapper)

show_all_images = ->
  noscript_wrapped_images = document.querySelectorAll(ELEMENTS_QUERY)
  noscript_wrapped_images.forEach(lazy_load_image_in_noscript_wrapper)

document.addEventListener "ready", ->
  lazy_load_images()

document.addEventListener "turbolinks:load", ->
  lazy_load_images()

# handle pritning of images: https://developer.mozilla.org/en-US/docs/Web/API/WindowEventHandlers/onbeforeprint
window.addEventListener "beforeprint", ->
  show_all_images()

mediaQueryList = window.matchMedia('print');
mediaQueryList.addListener (mql)->
  if mql.matches
    show_all_images()
