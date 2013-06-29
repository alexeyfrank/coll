(function() {
  this.App = angular.module('App', ['socket.io', 'ui.codemirror']);

  this.App.controller('DocumentCtrl', [
    '$scope', '$socket', function($scope, $socket) {
      var editor, textarea;
      $socket.forward('document:sync:completed', $scope);
      textarea = document.getElementById('text');
      $scope.lastChange = "";
      $scope.needSend = false;
      editor = CodeMirror(function(elt) {
        return textarea.parentNode.replaceChild(elt, textarea);
      });
      editor.on('change', function(doc) {
        if ($scope.lastChange === editor.getValue()) {
          return $scope.needSend = false;
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
          $scope.lastChange = data.content;
          console.log(editor.getScrollInfo());
          editor.setValue(data.content);
          if (savedSel) {
            return rangy.restoreSelection(savedSel, true);
          }
        }
      });
    }
  ]);

}).call(this);
