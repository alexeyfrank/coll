load 'application'

action 'sync', ->
  console.log 'sync log'
  socket().emit('document:sync:completed', content: 'TODO: set content')