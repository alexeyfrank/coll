load 'application'

action 'world', ->
  socket().emit('hello-world', {message: 'hello world from socket io!'});