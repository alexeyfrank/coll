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
      editor.on('change', function(doc, obj) {
        console.log(obj);
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
      }, 1);
      return $socket.on('message', function(data) {
        var newStr, patch, scrollInfo;
        if ($scope.lastChange !== data.content) {
          $scope.lastChange = data.content;
          patch = JsDiff.createPatch('', editor.getValue(), data.content, '', '');
          scrollInfo = editor.getCursor();
          newStr = JsDiff.applyPatch(editor.getValue(), patch);
          editor.setValue(newStr);
          return editor.setCursor(scrollInfo);
        }
      });
    }
  ]);

}).call(this);
