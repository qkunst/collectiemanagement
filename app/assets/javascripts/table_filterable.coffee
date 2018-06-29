# <label>Filter op kenteken <input type="text" id="registration-id-filter" data-filters="cars-table"></label>
# <div class="columns row">
#   <table class="sortable" id="cars-table">
#     <thead>
#       <tr>
#         <td date-filtered-by="registration-id-filter">Kenteken</td>

class FilterableTableField
  constructor: (@table) ->

  cleanText: (text) ->
    ("" + text).toLowerCase().replace(/[-]/g,"")

  filterWith: (field, value) ->
    cleanedValueText = @cleanText(value)
    columns = @table.querySelectorAll("thead th, thead td")
    tableBody = @table.querySelector('tbody')

    # by temporarily hiding the table body; intermediate reflows are prevented
    tableBody.setAttribute("hidden", "hidden")
    index = 0
    filterColumnIndexes = []
    columns.forEach (column) ->
      console.log column.dataset.filteredBy, field
      if column.dataset.filteredBy == field
        filterColumnIndexes.push index
      index++
    rows = @table.querySelectorAll("tbody tr")


    cleanTxt = @cleanText
    rows.forEach (row) ->
      rowValues = filterColumnIndexes.map (index) ->
        cleanTxt(row.children[index].innerText)

      rowFilteredText = " #{rowValues.join(' ')} "

      if rowFilteredText.search(cleanedValueText) >= 0
        row.removeAttribute("hidden")
      else
        row.setAttribute("hidden", "hidden")
    tableBody.removeAttribute("hidden")

  @changeListener = (e) ->
    if (e.target.dataset.filters)
      filter = e.target

      filterTable = document.getElementById(e.target.dataset.filters)

      table = new FilterableTableField(filterTable)
      table.filterWith(filter.id, filter.value)


document.addEventListener 'change', FilterableTableField.changeListener, true
document.addEventListener 'keyup', FilterableTableField.changeListener, true