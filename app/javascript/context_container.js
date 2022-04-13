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
      root.off('touchstart.contextContainer.closeArea');
      root.off('touchstart.contextContainer.clickLink');
      $("#context-container-almost-hidden-overlay").remove();
    }

    contextContainer.before( "<div id=\"context-container-almost-hidden-overlay\"></div>" );
    contextContainer.addClass("opened");

    var openInContextContainerFunction = function(urlToOpen) {
      if (contextContainer.data('url') != urlToOpen ) {
        if (urlToOpen.startsWith("http") && !urlToOpen.match(document.location.host)) {
          document.location = urlToOpen;
          return true;
        }
        $.ajax(urlToOpen).then(
          function(data){
            var focusArea = urlToOpen.match("#") ? urlToOpen.split("#")[1] : "main"
            var body = $(data).find(`#${focusArea}`);

            if (body.length == 0){
              console.warn(`No #${focusArea}-section found in the url (${urlToOpen})`)
            }
            contextContainer.html( body.html() );

            contextContainer.data('url', urlToOpen);
            collectieBeheerInit();

          }, closeFunction
        );
        return false;
      }
    }

    openInContextContainerFunction(urlToOpen);
    var openInContextContainerFunctionEventCallback = function(e) {
      if (e.target.getAttribute("target") != "_blank" && e.target.getAttribute("target") != "_self") {
        openInContextContainerFunction(e.target.href);
        return false;
      }
    }

    root.on('click.contextContainer.clickLink', "a", openInContextContainerFunctionEventCallback);
    root.on('click.contextContainer.closeArea', "#context-container-almost-hidden-overlay", closeFunction);
    root.on('touchstart.contextContainer.clickLink', "a", openInContextContainerFunctionEventCallback);
    root.on('touchstart.contextContainer.closeArea', "#context-container-almost-hidden-overlay", closeFunction);

  };
  $.fn.openInContext = function(options) {
    var opts = $.extend( {}, $.fn.openInContext.defaults, options );
    root = this;
    var openLinkEventCallback = function(e){
      var urlToOpen = e.target.href;
      createAndOpenUrlInContextContainer(urlToOpen);
      return false;
    }

    this.on('click.contextContainer.openLink', "a[data-open-in-context]", openLinkEventCallback);
    this.on('touchstart.contextContainer.openLink', "a[data-open-in-context]", openLinkEventCallback);
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