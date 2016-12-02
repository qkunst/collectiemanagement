$(function(){

  $("th[data-key]").each(function(index, elem){
    elem = $(elem);
    key_name = elem.data("key")
    console.log(elem);
  })
});