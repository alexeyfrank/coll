load 'application'

action 'sync', ->
  #console.log params()

  document = new Document(params.document)
  document.save

  socket().broadcast.send(content: 'TODO: set content')
