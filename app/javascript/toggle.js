var AltFoundation,
  indexOf = [].indexOf;

AltFoundation = (function() {
  class AltFoundation {};

  AltFoundation.Toggle = class Toggle {
    static handleToggle(targetElement) {
      var toggleClass, togglee, toggleeId;
      toggleeId = targetElement.dataset.qtoggle;
      if (toggleeId) {
        togglee = document.getElementById(toggleeId);
        toggleClass = targetElement.dataset.qtoggleClass;
        if (AltFoundation.Toggle.isShown(togglee, toggleClass)) {
          return AltFoundation.Toggle.hide(togglee, toggleClass);
        } else {
          return AltFoundation.Toggle.show(togglee, toggleClass);
        }
      }
    }

    static clickHandler(e) {
      e.preventDefault();
      AltFoundation.Toggle.handleToggle(e.target);
      return false;
    }

    static keyPressEventHandler(e) {
      e.preventDefault();
      AltFoundation.Toggle.handleToggle(e.target);
      return false;
    }

    static isShown(elem, toggleClass) {
      return !elem.classList.contains(toggleClass); //or togglee.style.
    }

    static init() {
      if (indexOf.call(window, 'ontouchstart') >= 0) { //.ontouchstart
        document.addDelegatedEventListener("touchend", "button[data-qtoggle]", AltFoundation.Toggle.clickHandler);
      } else {
        document.addDelegatedEventListener("click", "button[data-qtoggle]", AltFoundation.Toggle.clickHandler);
      }
      return document.addDelegatedEventListener("keypress", "button[data-qtoggle]", AltFoundation.Toggle.keyPressEventHandler);
    }

    static hide(elem, toggleClass) {
      elem.style.display = null;
      if (toggleClass) {
        return elem.classList.add(toggleClass);
      } else {
        return elem.style.display = "none";
      }
    }

    static show(elem, toggleClass) {
      elem.style.display = null;
      if (toggleClass) {
        return elem.classList.remove(toggleClass);
      } else {
        return elem.style.display = "block";
      }
    }

  };

  return AltFoundation;

}).call(this);

window.addEventListener("load", function(event) {
  return AltFoundation.Toggle.init();
});
