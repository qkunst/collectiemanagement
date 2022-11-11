document.addEventListener("keyup", function(e) {
  var class_to_add, i, index, input, j, len, len1, li_element, li_elements, line, list_to_filter, match, ref, results, search_text;
  if (e.target.classList.contains("list-filter")) {
    input = e.target;
    list_to_filter = document.getElementById(e.target.dataset["filters"]);
    search_text = input.value.toLocaleLowerCase();
    if (search_text.length > 0) {
      list_to_filter.classList.add("filtered");
      li_elements = list_to_filter.getElementsByTagName("li");
      results = [];
      for (i = 0, len = li_elements.length; i < len; i++) {
        li_element = li_elements[i];
        li_element.classList.remove("match");
        li_element.classList.remove("supermatch");
        match = -1;
        ref = li_element.textContent.toLocaleLowerCase().split(/\n/);
        for (index = j = 0, len1 = ref.length; j < len1; index = ++j) {
          line = ref[index];
          if (match === -1 && line.search(search_text) >= 0) {
            match = index;
          }
        }
        if (match >= 0) {
          class_to_add = "supermatch";
          if (match === 0) {
            class_to_add = "match";
          }
          results.push(li_element.classList.add(class_to_add));
        } else {
          results.push(void 0);
        }
      }
      return results;
    } else {
      return list_to_filter.classList.remove("filtered");
    }
  }
});
