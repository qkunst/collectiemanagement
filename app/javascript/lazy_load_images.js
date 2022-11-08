var ELEMENTS_QUERY, decodeEntities, lazy_load_image_in_noscript_wrapper, lazy_load_images, mediaQueryList, process_intersection_observer_entry, show_all_images;

ELEMENTS_QUERY = "noscript[data-lazy=\"lazy-load\"]";

decodeEntities = function(encodedString) {
  var textArea;
  // required for IE and Safari
  textArea = document.createElement('textarea');
  textArea.innerHTML = encodedString;
  return textArea.value;
};

lazy_load_image_in_noscript_wrapper = function(noscript_tag) {
  var fragment, parent;
  if (noscript_tag) {
    fragment = noscript_tag.innerHTML;
    parent = noscript_tag.parentElement;
    return parent.innerHTML = decodeEntities(fragment);
  }
};

process_intersection_observer_entry = function(entry) {
  var noscript_tag;
  if (entry.intersectionRatio > 0) {
    noscript_tag = entry.target.querySelector("noscript");
    if (noscript_tag) {
      return lazy_load_image_in_noscript_wrapper(noscript_tag);
    }
  }
};

lazy_load_images = function() {
  var intersectionObsOptions, intersectionObserver, noscript_wrapped_images, supportsIntersectionObserver;
  noscript_wrapped_images = document.querySelectorAll(ELEMENTS_QUERY);
  supportsIntersectionObserver = typeof IntersectionObserver === "function";
  if (supportsIntersectionObserver) {
    intersectionObsOptions = {
      root_margin: "100px"
    };
    intersectionObserver = new IntersectionObserver(function(entries) {
      return entries.forEach(process_intersection_observer_entry);
    }, intersectionObsOptions);
    return noscript_wrapped_images.forEach(function(e) {
      return intersectionObserver.observe(e.parentElement);
    });
  } else {
    return noscript_wrapped_images.forEach(lazy_load_image_in_noscript_wrapper);
  }
};

show_all_images = function() {
  var noscript_wrapped_images;
  noscript_wrapped_images = document.querySelectorAll(ELEMENTS_QUERY);
  return noscript_wrapped_images.forEach(lazy_load_image_in_noscript_wrapper);
};

window.addEventListener("load", function() {
  return lazy_load_images();
});

document.addEventListener("turbo:load", function() {
  return lazy_load_images();
});

// handle pritning of images: https://developer.mozilla.org/en-US/docs/Web/API/WindowEventHandlers/onbeforeprint
window.addEventListener("beforeprint", function() {
  return show_all_images();
});

mediaQueryList = window.matchMedia('print');

mediaQueryList.addListener(function(mql) {
  if (mql.matches) {
    return show_all_images();
  }
});
