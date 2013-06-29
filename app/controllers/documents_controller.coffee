load 'application'
JsDiff = require 'diff'

action 'sync', ->
  lastDocument = new Document(params.document)
  app.heap.push(lastDocument)  

  firstDocument = app.heap.pop()
  firstDocument.save (err) ->
    io().sockets.emit 'message', position: params.position, posDiff: params.posDiff, content: firstDocument.content
