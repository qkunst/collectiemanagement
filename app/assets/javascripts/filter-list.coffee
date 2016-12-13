document.addEventListener("keyup", (e)->
  if e.target.classList.contains "list-filter"
    input = e.target
    list_to_filter = document.getElementById(e.target.dataset["filters"])
    search_text = input.value.toLocaleLowerCase()
    if search_text.length > 0
      list_to_filter.classList.add "filtered"
      li_elements = list_to_filter.getElementsByTagName("li")
      for li_element in li_elements
        li_element.classList.remove "match"
        li_element.classList.remove "supermatch"
        match = -1
        for line, index in li_element.textContent.toLocaleLowerCase().split(/\n/)
          if match == -1 and line.search(search_text) >= 0
            match = index
        if match >= 0
          class_to_add = "supermatch"
          class_to_add = "match" if match == 0
          li_element.classList.add(class_to_add)
    else
      list_to_filter.classList.remove "filtered"

)