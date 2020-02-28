# I know, one shouldn't prototype so much.
# It can mess up other scripts-functioning.
# Well, bad for them.
#
# As long as I can enjoy rubyesque-ease :)

# ({a:1}).merge({b:2}) -> {a:1, b:2}
# Object::merge = (object) ->
#   for key, val of object
#     this[key] = val unless key == "extend"
#   this

# (5).times(function(){ console.log('hi'); }) -> logs 5 times 'hi'
Number::times = (fn) ->
  do fn for [1..@valueOf()] if @valueOf()
  return

# "title".capitalize() -> "Title"
String::capitalize = ->
  this.charAt(0).toUpperCase() + this.slice(1)

# [1,2,3,4].toSentence() -> "1, 2, 3 & 4"
Array::toSentence = (options)->
  defaultoptions =
    words_connector: ', '
    last_word_connector: ' & '

  options = extend defaultoptions, options
  last2 = []
  last2.push this.pop()
  last2.push this.pop()
  this.push last2.reverse().join(options.last_word_connector)
  this.join(", ")

# document.location.params() -> {q: "query"} (if search == '?q=query')
Location::params = ->
  params = {}
  query_string = window.location.search.substring(1)
  keyvaluepairs = query_string.split("&")
  for keyvaluepaired in keyvaluepairs
    keyvaluepair = keyvaluepaired.split("=")
    key = keyvaluepair[0]
    value = keyvaluepair[1]
    if (typeof params[key] == "undefined")
      params[key] = decodeURIComponent(value)
    else if (typeof params[keyvaluepair[0]] == "string")
      params[key] = [params[key], decodeURIComponent(value)]
    else
      params[key].push(decodeURIComponent(value));
  params

# document.addDelegatedEventListener("click", "a[href^='http']", -> confirm("external link") )
HTMLDocument::addDelegatedEventListener = (event, matcher, cb) ->
  newCB = (event) ->
    if (event.target.matches(matcher))
      return cb(event);
  this.addEventListener(event, newCB)

if (!Element::matches)
  Element::matches = Element::msMatchesSelector

# Nodelist
forEachMethod = (callback, thisArg) ->
  thisArg = thisArg || window
  for i in [0..this.length - 1]
    callback.call thisArg, this[i], i, this

if window.NodeList and !NodeList::forEach
  NodeList::forEach = forEachMethod

if window.HTMLCollection and !HTMLCollection::forEach
  HTMLCollection::forEach = forEachMethod