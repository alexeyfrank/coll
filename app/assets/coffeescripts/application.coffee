
@App = angular.module('App', ['socket.io', 'ui.codemirror'])


@App.controller 'DocumentCtrl', [ '$scope', '$socket', ($scope, $socket) ->
  $socket.forward 'document:sync:completed', $scope
  textarea = document.getElementById('text')
  
  $scope.lastChange = ""
  $scope.fromSocket = false
  $scope.needSend = true

  editor = CodeMirror (elt) ->
    textarea.parentNode.replaceChild(elt, textarea)

  editor.on 'change', (doc) ->
    if $scope.fromSocket
      $scope.needSend = false
      $scope.fromSocket = false
    else
     $scope.needSend = true

  setInterval ->
    if $scope.needSend
      $scope.lastChange = editor.getValue()
      $socket.emit 'document:sync', 
        document:
          content: value,
          timestamp: new Date().getTime()  
      $scope.needSend = false
  , 2000

  $socket.on 'message', (data) ->
    if ($scope.lastChange != data.content)
      $scope.fromSocket = true
      editor.setValue(data.content)
]

