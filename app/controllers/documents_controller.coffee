load 'application'

action 'show', ->
  render
    title: "documents#show"

action 'create', ->
  Document.create body.Document, (err, document) =>
    if err
      flash 'error', 'Document can not be created'
      redirect path_to.root
    else
      flash 'info', 'Document created'
      redirect path_to.document(document.id)

action 'sync', ->
  console.log 'sync log'
  socket().emit('document:sync:completed', content: 'TODO: set content')