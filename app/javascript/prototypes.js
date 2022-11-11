// from: https://gist.github.com/murb/a8823e7a2d6fc9613b3c5c00a0225809

export default function() {
  var forEachMethod;

  Object.prototype.merge = function(object) {
    var key, val;
    for (key in object) {
      val = object[key];
      if (key !== "extend") {
        this[key] = val;
      }
    }
    return this;
  };

  Number.prototype.times = function(fn) {
    var _i, _ref;
    if (this.valueOf()) {
      for (_i = 1, _ref = this.valueOf(); 1 <= _ref ? _i <= _ref : _i >= _ref; 1 <= _ref ? _i++ : _i--) {
        fn();
      }
    }
  };

  String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
  };

  Array.prototype.toSentence = function(options) {
    var defaultoptions, last2;
    defaultoptions = {
      words_connector: ', ',
      last_word_connector: ' & '
    };
    options = extend(defaultoptions, options);
    last2 = [];
    last2.push(this.pop());
    last2.push(this.pop());
    this.push(last2.reverse().join("" + options.last_word_connector));
    return this.join(", ");
  };

  Array.prototype.sample = function() {
    var entry;
    entry = Math.floor(Math.random() * this.length);
    return this[entry];
  };

  Location.prototype.params = function() {
    var key, keyvaluepair, keyvaluepaired, keyvaluepairs, params, query_string, value, _i, _len;
    params = {};
    query_string = window.location.search.substring(1);
    keyvaluepairs = query_string.split("&");
    for (_i = 0, _len = keyvaluepairs.length; _i < _len; _i++) {
      keyvaluepaired = keyvaluepairs[_i];
      keyvaluepair = keyvaluepaired.split("=");
      key = keyvaluepair[0];
      value = keyvaluepair[1];
      if (typeof params[key] === "undefined") {
        params[key] = decodeURIComponent(value);
      } else if (typeof params[keyvaluepair[0]] === "string") {
        params[key] = [params[key], decodeURIComponent(value)];
      } else {
        params[key].push(decodeURIComponent(value));
      }
    }
    return params;
  };

  HTMLDocument.prototype.addDelegatedEventListener = function(event, matcher, cb) {
    var newCB;
    newCB = function(event) {
      if (event.target.matches(matcher)) {
        return cb(event);
      }
    };
    return this.addEventListener(event, newCB);
  };

  if (!Element.prototype.matches) {
    Element.prototype.matches = Element.prototype.msMatchesSelector;
  }

  forEachMethod = function(callback, thisArg) {
    var i, _i, _ref, _results;
    thisArg = thisArg || window;
    _results = [];
    for (i = _i = 0, _ref = this.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
      _results.push(callback.call(thisArg, this[i], i, this));
    }
    return _results;
  };

  if (window.NodeList && !NodeList.prototype.forEach) {
    NodeList.prototype.forEach = forEachMethod;
  }

  if (window.HTMLCollection && !HTMLCollection.prototype.forEach) {
    HTMLCollection.prototype.forEach = forEachMethod;
  }

}