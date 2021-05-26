class AltFoundation
  class @Toggle
    @handleToggle: (targetElement) ->
      toggleeId = targetElement.dataset.qtoggle
      if toggleeId
        togglee = document.getElementById(toggleeId)
        toggleClass = targetElement.dataset.qtoggleClass
        if AltFoundation.Toggle.isShown(togglee, toggleClass)
          AltFoundation.Toggle.hide(togglee, toggleClass)
        else
          AltFoundation.Toggle.show(togglee, toggleClass)

    @clickHandler: (e) ->
      e.preventDefault();
      AltFoundation.Toggle.handleToggle(e.target)
      return false;

    @keyPressEventHandler: (e) ->
      e.preventDefault();
      AltFoundation.Toggle.handleToggle(e.target)
      return false;

    @isShown: (elem, toggleClass) ->
      !elem.classList.contains(toggleClass) #or togglee.style.

    @init: () ->
      if 'ontouchstart' in window #.ontouchstart
        document.addDelegatedEventListener("touchend", "button[data-qtoggle]", AltFoundation.Toggle.clickHandler)
      else
        document.addDelegatedEventListener("click", "button[data-qtoggle]", AltFoundation.Toggle.clickHandler)
      document.addDelegatedEventListener("keypress", "button[data-qtoggle]", AltFoundation.Toggle.keyPressEventHandler)

    @hide: (elem, toggleClass) ->
      elem.style.display = null;
      if toggleClass
        elem.classList.add(toggleClass)
      else
        elem.style.display = "none"

    @show: (elem, toggleClass) ->
      elem.style.display = null;

      if toggleClass
        elem.classList.remove(toggleClass)
      else
        elem.style.display = "block";



window.addEventListener "load", (event)->
  AltFoundation.Toggle.init()
