var blurElem;

blurElem = function(e) {
  if (e.target.classList) {
    return e.target.classList.add("blurred");
  }
};

document.addEventListener('blur', blurElem, true);
