load 'application'

action 'sync', ->
  #console.log params()

  document = new Document(params.document)
  document.save
  io().sockets.emit('document:sync:completed', document);
