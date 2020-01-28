blurElem = (e) ->
  e.target.classList.add("blurred") if (e.target.classList);

document.addEventListener 'blur', blurElem, true