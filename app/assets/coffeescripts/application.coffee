
@App = angular.module('App', ['socket.io', 'ui.codemirror'])


@App.controller 'DocumentCtrl', [ '$scope', '$socket', ($scope, $socket) ->
  $socket.forward 'document:sync:completed', $scope
  textarea = document.getElementById('text')
  
  $scope.lastChange = ""
  $scope.needSend = false

  editor = CodeMirror (elt) -> textarea.parentNode.replaceChild(elt, textarea)

  editor.on 'change', (doc) ->
    if $scope.lastChange == editor.getValue()
      $scope.needSend = false
    else
      $scope.needSend = true

  setInterval ->
    if $scope.needSend
      $scope.lastChange = editor.getValue()
      $socket.emit 'document:sync', 
        document:
          content: $scope.lastChange,
          timestamp: new Date().getTime()  
      $scope.needSend = false
  , 1

  $socket.on 'message', (data) ->
    if ($scope.lastChange != data.content)
      $scope.lastChange = data.content
      patch = JsDiff.createPatch('', editor.getValue(), data.content, '', '')
      scrollInfo = editor.getCursor()
      newStr = JsDiff.applyPatch(editor.getValue(), patch)
      editor.setValue(newStr)
      editor.setCursor scrollInfo

]

