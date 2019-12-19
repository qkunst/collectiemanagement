# Source: https://gist.github.com/murb/22fa0fc53955629567bd370037b6a1e3
#
# <table class="sortable">
#   <thead>
#      <tr>
#         <td /><th data-sort-empty-always-last="true" />
#      </tr>
#   </thead>
#   <tbody>
#     <tr>
#       <td
#         class="number"            either use class="number"
#         data-sorttype="number"      or the data-sorttype
#         data-sortkey="12.2"       override cells' content with this sortkey
#
# Minimal CSS along the lines of:
#
#    table.sortable {
#      thead td, thead th {
#        &[aria-sort=descending] {
#          &::after {
#            content: '▼';
#          }
#        }
#        &[aria-sort=ascending] {
#          &::after {
#            content: '▲';
#          }
#        }
#      }
#    }
#
# TODO:
#  Keyboard usage improvements
#
class SortableTable
  ASC = 'ascending'
  DESC = 'descending'

  constructor: (@table) ->

  sort: (@columnHead) ->
    @order = if (@columnHead.getAttribute("aria-sort") == ASC)
      DESC
    else
      ASC

    @sortEmptyAlwaysLast = if (@columnHead.dataset and @columnHead.dataset.sortEmptyAlwaysLast and @columnHead.dataset.sortEmptyAlwaysLast != "false")
      true
    else
      false

    @resetSortsAndSetColumnIndex()
    rows = @reorderRows()
    @replaceTBody(rows)

  nodeListToArray: (nodelist) ->
    arr = []
    nodelist.forEach((i) ->
      arr.push(i)
    )
    arr

  replaceTBody: (rows) ->
    tbody = document.createElement("tbody")
    for row in rows
      tbody.appendChild row

    @table.removeChild(@table.getElementsByTagName('tbody')[0])
    @table.appendChild(tbody)

  resetSortsAndSetColumnIndex: ->
    tableColumnHeads = @table.querySelectorAll("thead th, thead td")
    for tableColumnHead, index in tableColumnHeads
      tableColumnHead.removeAttribute("aria-sort")
      if (tableColumnHead == @columnHead)
        @columnIndex = index

    @columnHead.setAttribute("aria-sort", @order)


  reorderRows: ->
    columnIndex = @columnIndex
    orderMultiplier = if (@order == DESC)
      -1
    else
      1

    sortEmptyAlwaysLastMultiplier = if @sortEmptyAlwaysLast and @order == ASC
      -1
    else
      1

    extractSortableRowValue = (row) ->
      cell = row.querySelectorAll("td, th")[columnIndex]
      isNumber = (cell.dataset and cell.dataset.sorttype == 'number') or cell.classList.contains('number')

      value = if (cell.dataset and Object.keys(cell.dataset).includes("sortkey"))
        cell.dataset.sortkey
      else
        cell.innerText

      # empty values for numbers
      if isNumber and ((value == "") or (typeof value == 'undefined'))
        value = -9999999999 * sortEmptyAlwaysLastMultiplier
      else if isNumber
        value = parseFloat(value)
      else if (typeof value == "string")
        value = value.toLowerCase()

      value

    rowSortFunction = (aRow, bRow) ->
      aValue = extractSortableRowValue(aRow)
      bValue = extractSortableRowValue(bRow)
      if aValue < bValue
        -1 * orderMultiplier
      else if aValue > bValue
        1 * orderMultiplier
      else
        0

    rows = @nodeListToArray(@table.querySelectorAll("tbody tr"))
    rows.sort rowSortFunction

  @registerSortableTableEventCallback: (e) ->
    if (e.target.parentNode.parentNode.nodeName.toLowerCase() == 'thead' && e.target.parentNode.parentNode.parentNode.classList.contains('sortable'))
      clickedColumnHead = e.target

      table = new SortableTable(clickedColumnHead.parentNode.parentNode.parentNode)
      table.sort(clickedColumnHead)

document.addEventListener 'click', SortableTable.registerSortableTableEventCallback, true
document.addEventListener 'touchstart', SortableTable.registerSortableTableEventCallback, true