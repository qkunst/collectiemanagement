reportInit = ->
  $('#locaties tr').hide()
  $('#locaties tr.location_raw, #locaties tr.span-6').show()

$(document).on 'ready', reportInit
$(document).on 'turbolinks:load', reportInit


$(document).on 'click', '#locaties tr.span-6 td[colspan], #locaties tr.span-4 td[colspan]', (event_super_row_click)->
  # console.log(event_super_row_click)
  $super_row = $(event_super_row_click.target).parent()
  if $super_row.hasClass('expanded')
    $super_row.removeClass('expanded')
    if $super_row.hasClass('span-6')
      $super_row.nextUntil('.span-6').hide().removeClass('expanded')
    else if $super_row.hasClass('span-4')
      $super_row.nextUntil('.span-4').hide().removeClass('expanded')
  else
    $super_row.addClass('expanded')
    if $super_row.hasClass('span-6')
      $super_row.nextUntil('.span-6', '.span-5, .span-4').show()
    else if $super_row.hasClass('span-4')
      $super_row.nextUntil('.span-4, .span-6', '.span-3, .span-2').show()