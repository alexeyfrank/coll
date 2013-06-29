load 'application'

action 'sync', ->
  #console.log params()

  document = new Document(params.document)
  document.save
  socket().emit('document:sync:completed', document);
