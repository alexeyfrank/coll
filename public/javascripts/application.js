(function() {
  this.App = angular.module('App', ['socket.io', 'ui.codemirror']);

  this.App.controller('DocumentCtrl', [
    '$scope', '$socket', function($scope, $socket) {
      var editor, textarea;
      $socket.forward('document:sync:completed', $scope);
      textarea = document.getElementById('text');
      $scope.fromSocket = false;
      $scope.needSend = true;
      editor = CodeMirror(function(elt) {
        return textarea.parentNode.replaceChild(elt, textarea);
      });
      editor.on('change', function(doc) {
        if ($scope.fromSocket) {
          $scope.needSend = false;
          return $scope.fromSocket = false;
        } else {
          return $scope.needSend = true;
        }
      });
      setInterval(function() {
        var value;
        if ($scope.needSend) {
          value = editor.getValue();
          $socket.emit('document:sync', {
            document: {
              content: value,
              timestamp: new Date().getTime()
            }
          });
          return $scope.needSend = false;
        }
      }, 2000);
      return $socket.on('message', function(data) {
        $scope.fromSocket = true;
        return editor.setValue(data.content);
      });
    }
  ]);

}).call(this);
