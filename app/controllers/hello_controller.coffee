load 'application'

action 'world', ->
  socket().emit('hello-world', {data: 'hello world from socket io!'});