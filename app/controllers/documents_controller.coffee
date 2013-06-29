load 'application'

action 'sync', ->
  #console.log params()

  document = new Document(params.document)
  document.save


Document.findOne({order: 'timestamp DESC'}, (err, doc) ->
  io().broadcast.emit 'message', doc[0]
