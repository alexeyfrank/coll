#=require_tree ./

angular.module("socket-io", []).provider "$socket", ->
  
  # when forwarding events, prefix the event name
  prefix = ""
  
  # expose to provider
  @$get = ($rootScope, $timeout) ->
    socket = io.connect()
    asyncAngularify = (callback) ->
      ->
        args = arguments
        $timeout (->
          callback.apply socket, args
        ), 0

    addListener = (eventName, callback) ->
      socket.on eventName, asyncAngularify(callback)

    wrappedSocket =
      on: addListener
      addListener: addListener
      emit: (eventName, data, callback) ->
        if callback
          socket.emit eventName, data, asyncAngularify(callback)
        else
          socket.emit eventName, data

      removeListener: ->
        args = arguments_
        socket.removeListener.apply socket, args

      
      # when socket.on('someEvent', fn (data) { ... }),
      # call scope.$broadcast('someEvent', data)
      forward: (events, scope) ->
        events = [events]  if events instanceof Array is false
        scope = $rootScope  unless scope
        events.forEach (eventName) ->
          prefixed = prefix + eventName
          forwardEvent = asyncAngularify((data) ->
            scope.$broadcast prefixed, data
          )
          scope.$on "$destroy", ->
            socket.removeListener eventName, forwardEvent

          socket.on eventName, forwardEvent


    wrappedSocket

  @prefix = (newPrefix) ->
    prefix = newPrefix


@App = angular.module('App', ['socket-io'])

@App.controller 'DocumentCtrl', [ '$scope', '$socket', ($scope, $socket) ->
  textarea = document.getElementById('textarea')
  myCodeMirror = CodeMirror (elt) ->
    textarea.parentNode.replaceChild(elt, textarea)
  ,
  { value: textarea.value} 

  $socket.forward 'document:sync:completed', $scope
  $scope.$on 'document:sync:completed', (ev, data) ->
    $scope.content = data.content

  $scope.sync = ->
    $socket.emit 'document:sync', content: $scope.content, timestamp: new Date().getTime()
]

