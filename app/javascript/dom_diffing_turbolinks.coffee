morphdom = require("morphdom").default;

Turbolinks.SnapshotRenderer::assignNewBody = ->
  morphdom(document.body,@newBody,{})
  # Turbolinks.dispatch("DOMContentLoaded")
  # return true #document.body

  # # Virtualize the current body
  # curBody = virtualize document.body
  #
  # # Virtualize the new body
  # newBody = virtualize @newBody
  #
  # # Diff the 2 virtual DOMs, creating a set of patches
  # patches = diff curBody, newBody
  #
  # # Apply the resulting patches to the current DOM
  # patch document.body, patches
