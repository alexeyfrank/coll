$ ->
  socket = io.connect()
  socket.on 'hello-world', (data) ->
    console.log(data)

  $('#click-me').click ->
    socket.emit('hello-world', { my: 'data' })