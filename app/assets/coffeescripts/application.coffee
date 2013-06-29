
@App = angular.module('App', ['socket.io', 'ui.codemirror'])


@App.controller 'DocumentCtrl', [ '$scope', '$socket', ($scope, $socket) ->
  $socket.forward 'document:sync:completed', $scope
  textarea = document.getElementById('text')

  editor = CodeMirror (elt) ->
    textarea.parentNode.replaceChild(elt, textarea)

  setInterval ->
    value = editor.getValue()
    $socket.emit 'document:sync', 
      document:
        content: value,
        timestamp: new Date().getTime()  
  , 2000

  $scope.$on 'document:sync:completed', (ev, data) ->
    editor.setValue(data.content)
]

