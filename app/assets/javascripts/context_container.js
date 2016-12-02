(function( $ ) {
  $.fn.openInContext = function(options) {
    var opts = $.extend( {}, $.fn.openInContext.defaults, options );

    var root = this;

    root.on('click.contextContainer.openLink', "a[data-open-in-context]", function(e){
      var contextContainer = $("#context-container");
      var closeFunction = function(){
        //cleanup
        contextContainer.removeClass("opened");
        root.off('click.contextContainer.closeArea');
        root.off('click.contextContainer.clickLink');
        $("#context-container-almost-hidden-overlay").remove();
      }
      var urlToOpen = e.target.href

      contextContainer.before( "<div id=\"context-container-almost-hidden-overlay\"></div>" );
      contextContainer.addClass("opened");

      var openInContextContainerFunction = function(urlToOpen) {
        if (contextContainer.data('url') != urlToOpen ) {
          $.ajax(urlToOpen).then(
            function(data){
              var body = $(data).find("#main");
              contextContainer.html( body.html() );
              contextContainer.data('url', urlToOpen);
            }, closeFunction
          );
        }
      }

      openInContextContainerFunction(urlToOpen);


      root.on('click.contextContainer.clickLink', "a", function(e) {
        openInContextContainerFunction(e.target.href);
        return false;
      });
      root.on('click.contextContainer.closeArea', "#context-container-almost-hidden-overlay", closeFunction);
      return false;
    });
  };

  $.fn.openInContext.defaults = {}
}( jQuery ));

$(document).openInContext();