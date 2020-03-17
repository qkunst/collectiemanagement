// Source: https://gist.github.com/murb/22fa0fc53955629567bd370037b6a1e3

// <table class="sortable">
//   <thead>
//      <tr>
//         <td /><th data-sort-empty-always-last="true" />
//      </tr>
//   </thead>
//   <tbody>
//     <tr>
//       <td
//         class="number"            either use class="number"
//         data-sorttype="number"      or the data-sorttype
//         data-sortkey="12.2"       override cells' content with this sortkey

// Minimal CSS along the lines of:

//    table.sortable {
//      thead td, thead th {
//        &[aria-sort=descending] {
//          &::after {
//            content: '▼';
//          }
//        }
//        &[aria-sort=ascending] {
//          &::after {
//            content: '▲';
//          }
//        }
//      }
//    }

// TODO:
//  Keyboard usage improvements

var SortableTable;

SortableTable = (function() {
  var ASC, DESC;

  class SortableTable {
    constructor(table1) {
      this.table = table1;
    }

    sort(columnHead) {
      var rows;
      this.columnHead = columnHead;
      this.order = (this.columnHead.getAttribute("aria-sort") === ASC) ? DESC : ASC;
      this.sortEmptyAlwaysLast = (this.columnHead.dataset && this.columnHead.dataset.sortEmptyAlwaysLast && this.columnHead.dataset.sortEmptyAlwaysLast !== "false") ? true : false;
      this.resetSortsAndSetColumnIndex();
      rows = this.reorderRows();
      return this.replaceTBody(rows);
    }

    nodeListToArray(nodelist) {
      var arr;
      arr = [];
      nodelist.forEach(function(i) {
        return arr.push(i);
      });
      return arr;
    }

    replaceTBody(rows) {
      var j, len, row, tbody;
      tbody = document.createElement("tbody");
      for (j = 0, len = rows.length; j < len; j++) {
        row = rows[j];
        tbody.appendChild(row);
      }
      this.table.removeChild(this.table.getElementsByTagName('tbody')[0]);
      return this.table.appendChild(tbody);
    }

    resetSortsAndSetColumnIndex() {
      var index, j, len, tableColumnHead, tableColumnHeads;
      tableColumnHeads = this.table.querySelectorAll("thead th, thead td");
      for (index = j = 0, len = tableColumnHeads.length; j < len; index = ++j) {
        tableColumnHead = tableColumnHeads[index];
        tableColumnHead.removeAttribute("aria-sort");
        if (tableColumnHead === this.columnHead) {
          this.columnIndex = index;
        }
      }
      return this.columnHead.setAttribute("aria-sort", this.order);
    }

    reorderRows() {
      var columnIndex, extractSortableRowValue, orderMultiplier, rowSortFunction, rows, sortEmptyAlwaysLastMultiplier;
      columnIndex = this.columnIndex;
      orderMultiplier = (this.order === DESC) ? -1 : 1;
      sortEmptyAlwaysLastMultiplier = this.sortEmptyAlwaysLast && this.order === ASC ? -1 : 1;
      extractSortableRowValue = function(row) {
        var cell, isNumber, value;
        cell = row.querySelectorAll("td, th")[columnIndex];
        isNumber = (cell.dataset && cell.dataset.sorttype === 'number') || cell.classList.contains('number');
        value = (cell.dataset && Object.keys(cell.dataset).includes("sortkey")) ? cell.dataset.sortkey : cell.innerText;
        // empty values for numbers
        if (isNumber && ((value === "") || (typeof value === 'undefined'))) {
          value = -9999999999 * sortEmptyAlwaysLastMultiplier;
        } else if (isNumber) {
          value = parseFloat(value);
        } else if (typeof value === "string") {
          value = value.toLowerCase();
        }
        return value;
      };
      rowSortFunction = function(aRow, bRow) {
        var aValue, bValue;
        aValue = extractSortableRowValue(aRow);
        bValue = extractSortableRowValue(bRow);
        if (aValue < bValue) {
          return -1 * orderMultiplier;
        } else if (aValue > bValue) {
          return 1 * orderMultiplier;
        } else {
          return 0;
        }
      };
      rows = this.nodeListToArray(this.table.querySelectorAll("tbody tr"));
      return rows.sort(rowSortFunction);
    }

    static registerSortableTableEventCallback(e) {
      var clickedColumnHead, table;
      if (e.target.parentNode.parentNode.nodeName.toLowerCase() === 'thead' && e.target.parentNode.parentNode.parentNode.classList.contains('sortable')) {
        clickedColumnHead = e.target;
        table = new SortableTable(clickedColumnHead.parentNode.parentNode.parentNode);
        return table.sort(clickedColumnHead);
      }
    }

  };

  ASC = 'ascending';

  DESC = 'descending';

  return SortableTable;

}).call(this);

document.addEventListener('click', SortableTable.registerSortableTableEventCallback, true);

document.addEventListener('touchstart', SortableTable.registerSortableTableEventCallback, true);
