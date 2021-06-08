const findParentMatching = (element, matcher) => {
  if (element.matches(matcher)) {
    return element
  } else if (element.matches("html")) {
    return null;
  } else if (element.parentElement.matches(matcher)) {
    return element.parentElement;
  } else {
    return findParentMatching(element.parentElement, matcher)
  }
}

document.addEventListener('mousedown', (e) => {
  const target = e.target;

  if (!target.matches) {
    return true; // ignore rest of method; unsupported element
  }

  if ( target.matches("input") || target.matches("a")) {
    // skip when action is triggered
    return null;
  }

  // adapted from https://inclusive-components.design/cards/
  if ( target.matches(".js-block-link, .js-block-link *") ) {
    const goalTarget = findParentMatching(target, ".js-block-link");
    const link = goalTarget.querySelector('a');

    const down = +new Date();

    target.addEventListener('mouseup', () => {
      const up = +new Date();
      if ((up - down) < 200) {
        link.click();
      }
    });
  }
})