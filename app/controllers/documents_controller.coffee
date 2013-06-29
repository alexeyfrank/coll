load 'application'

action 'show', ->
  render
    title: "documents#show"

action 'sync', ->
  console.log 'sync log'
  socket().emit('document:sync:completed', content: 'TODO: set content')