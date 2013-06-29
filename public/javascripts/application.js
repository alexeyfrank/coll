(function() {
  $(function() {
    var socket;
    socket = io.connect();
    socket.on('hello-world', function(data) {
      return console.log(data);
    });
    return $('#click-me').click(function() {
      return socket.emit('hello-world', {
        my: 'data'
      });
    });
  });

}).call(this);
