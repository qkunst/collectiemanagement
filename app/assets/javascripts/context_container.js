(function( $ ) {
  var root = null;

  var createAndOpenUrlInContextContainer = function(urlToOpen) {
    if (typeof urlToOpen === 'undefined' || urlToOpen == '')
      return false;


    var contextContainer = $("#context-container");
    var closeFunction = function(){
      //cleanup
      contextContainer.removeClass("opened");
      root.off('click.contextContainer.closeArea');
      root.off('click.contextContainer.clickLink');
      $("#context-container-almost-hidden-overlay").remove();
    }

    contextContainer.before( "<div id=\"context-container-almost-hidden-overlay\"></div>" );
    contextContainer.addClass("opened");

    var openInContextContainerFunction = function(urlToOpen) {
      if (contextContainer.data('url') != urlToOpen ) {
        $.ajax(urlToOpen).then(
          function(data){
            var body = $(data).find("#main");
            if (body.length == 0){
              console.warn("No #main-section found in the url ("+urlToOpen+")")
            }
            contextContainer.html( body.html() );
            contextContainer.data('url', urlToOpen);
          }, closeFunction
        );
        return false;
      }
    }

    openInContextContainerFunction(urlToOpen);


    root.on('click.contextContainer.clickLink', "a", function(e) {
      openInContextContainerFunction(e.target.href);
      return false;
    });
    root.on('click.contextContainer.closeArea', "#context-container-almost-hidden-overlay", closeFunction);

  };
  $.fn.openInContext = function(options) {
    var opts = $.extend( {}, $.fn.openInContext.defaults, options );
    root = this;

    this.on('click.contextContainer.openLink', "a[data-open-in-context]", function(e){
      var urlToOpen = e.target.href;
      createAndOpenUrlInContextContainer(urlToOpen);
      return false;
    });
    $(function(e) {
      if (document.location.params) {
        // https://gist.github.com/murb/a8823e7a2d6fc9613b3c5c00a0225809
        urlToOpen = document.location.params()["show_in_context"]
        createAndOpenUrlInContextContainer(urlToOpen);
      }
    });
  };

  $.fn.openInContext.defaults = {}
}( jQuery ));

$(document).openInContext();