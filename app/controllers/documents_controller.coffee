load 'application'
JsDiff = require 'diff'

action 'sync', ->
  #console.log params()

  Document.findOne {order: 'timestamp DESC'}, (err, doc) ->
    document = new Document(params.document)
    oldContent = if doc then doc.content else ""
    newContent = document.content
    document.save (err) ->
      patch = JsDiff.createPatch('', oldContent, newContent, '', '')
      console.log(patch)
      io().sockets.emit 'message', pos: params.position, posDiff: params.posDiff, diff: patch, content: document.content if doc
