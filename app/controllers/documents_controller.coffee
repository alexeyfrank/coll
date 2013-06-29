load 'application'
JsDiff = require 'diff'

action 'sync', ->
  lastDocument = new Document(params.document)
  app.heap.push(lastDocument)  

  while !app.heap.empty()
    doc = app.heap.pop()
    doc.save (err) ->
      io().sockets.emit 'message', position: { ch: doc.positionCh, line: doc.positionLine}, posDiff: {ch: doc.posDiffCh, line: doc.posDiffLine}, content: firstDocument.content
