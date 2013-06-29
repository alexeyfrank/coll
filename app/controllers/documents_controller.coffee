load 'application'

action 'sync', ->
  #console.log params()

  document = new Document(params.document)
  document.save (err) ->
    Document.findOne {order: 'timestamp DESC'}, (err, doc) ->
      io().broadcast.emit 'message', doc if doc
