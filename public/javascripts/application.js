(function() {
  this.App = angular.module('App', ['socket.io', 'ui.codemirror']);

  this.App.controller('DocumentCtrl', [
    '$scope', '$socket', function($scope, $socket) {
      var editor, textarea;
      $socket.forward('document:sync:completed', $scope);
      textarea = document.getElementById('text');
      $scope.lastChange = "";
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
        if ($scope.needSend) {
          $scope.lastChange = editor.getValue();
          $socket.emit('document:sync', {
            document: {
              content: $scope.lastChange,
              timestamp: new Date().getTime()
            }
          });
          return $scope.needSend = false;
        }
      }, 2000);
      return $socket.on('message', function(data) {
        if ($scope.lastChange !== data.content) {
          $scope.fromSocket = true;
          return editor.setValue(data.content);
        }
      });
    }
  ]);

}).call(this);
