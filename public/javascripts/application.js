(function() {
  angular.module("socket-io", []).provider("$socket", function() {
    var prefix;
    prefix = "";
    this.$get = function($rootScope, $timeout) {
      var addListener, asyncAngularify, socket, wrappedSocket;
      socket = io.connect();
      asyncAngularify = function(callback) {
        return function() {
          var args;
          args = arguments;
          return $timeout((function() {
            return callback.apply(socket, args);
          }), 0);
        };
      };
      addListener = function(eventName, callback) {
        return socket.on(eventName, asyncAngularify(callback));
      };
      wrappedSocket = {
        on: addListener,
        addListener: addListener,
        emit: function(eventName, data, callback) {
          if (callback) {
            return socket.emit(eventName, data, asyncAngularify(callback));
          } else {
            return socket.emit(eventName, data);
          }
        },
        removeListener: function() {
          var args;
          args = arguments_;
          return socket.removeListener.apply(socket, args);
        },
        forward: function(events, scope) {
          if (events instanceof Array === false) {
            events = [events];
          }
          if (!scope) {
            scope = $rootScope;
          }
          return events.forEach(function(eventName) {
            var forwardEvent, prefixed;
            prefixed = prefix + eventName;
            forwardEvent = asyncAngularify(function(data) {
              return scope.$broadcast(prefixed, data);
            });
            scope.$on("$destroy", function() {
              return socket.removeListener(eventName, forwardEvent);
            });
            return socket.on(eventName, forwardEvent);
          });
        }
      };
      return wrappedSocket;
    };
    return this.prefix = function(newPrefix) {
      return prefix = newPrefix;
    };
  });

  this.App = angular.module('App', ['socket-io']);

  this.App.controller('DocumentCtrl', [
    '$scope', '$socket', function($scope, $socket) {
      $socket.forward('document:sync:completed', $scope);
      $scope.$on('document:sync:completed', function(ev, data) {
        return $scope.content = data.content;
      });
      return $scope.sync = function() {
        return $socket.emit('document:sync', {
          content: $scope.content,
          timestamp: new Date().getTime()
        });
      };
    }
  ]);

}).call(this);
