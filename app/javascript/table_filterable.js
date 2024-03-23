// <label>Filter <input type="text" id="id-of-input-for-filter" data-filters="id-of-table-to-filter"></label>
// <div class="columns row">
//   <table class="sortable" id="id-of-table-to-filter">
//     <thead>
//       <tr>
//         <th data-filtered-by="id-of-input-for-filter">Column A</th>
var FilterableTableField;

FilterableTableField = class FilterableTableField {
  constructor(table1) {
    this.table = table1;
  }

  cleanText(text) {
    return ("" + text).toLowerCase().replace(/[-]/g, "");
  }

  filterWith(field, value) {
    var cleanTxt, cleanedValueText, columns, filterColumnIndexes, index, rows, tableBody;
    cleanedValueText = this.cleanText(value);
    columns = this.table.querySelectorAll("thead th, thead td");
    tableBody = this.table.querySelector('tbody');
    // by temporarily hiding the table body; intermediate reflows are prevented
    tableBody.setAttribute("hidden", "hidden");
    index = 0;
    filterColumnIndexes = [];
    columns.forEach(function (column) {
      if (column.dataset.filteredBy === field) {
        filterColumnIndexes.push(index);
      }
      return index++;
    });
    rows = this.table.querySelectorAll("tbody tr");
    cleanTxt = this.cleanText;
    rows.forEach(function (row) {
      var rowFilteredText, rowValues;
      rowValues = filterColumnIndexes.map(function (index) {
        return cleanTxt(row.children[index].innerText);
      });
      rowFilteredText = ` ${rowValues.join(' ')} `;
      if (rowFilteredText.search(cleanedValueText) >= 0) {
        return row.removeAttribute("hidden");
      } else {
        return row.setAttribute("hidden", "hidden");
      }
    });
    return tableBody.removeAttribute("hidden");
  }

  static changeListener(e) {
    var filter, filterTable, table;
    if (e.target.dataset.filters) {
      filter = e.target;
      filterTable = document.querySelector("table#" + e.target.dataset.filters);
      if (filterTable) {
        table = new FilterableTableField(filterTable);
        return table.filterWith(filter.id, filter.value);
      }
    }
  }

};

document.addEventListener('change', FilterableTableField.changeListener, true);
document.addEventListener('keyup', FilterableTableField.changeListener, true);
