load 'application'

action 'show', ->
  render
    title: "documents#show"

action 'sync', ->
  socket().emit('document:sync:completed', content: 'TODO: set content')