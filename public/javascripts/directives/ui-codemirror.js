(function() {
  angular.module("ui.codemirror", []).constant("uiCodemirrorConfig", {}).directive("uiCodemirror", [
    "uiCodemirrorConfig", "$timeout", function(uiCodemirrorConfig, $timeout) {
      "use strict";
      var events;
      events = ["cursorActivity", "viewportChange", "gutterClick", "focus", "blur", "scroll", "update"];
      return {
        restrict: "A",
        require: "ngModel",
        link: function(scope, elm, attrs, ngModel) {
          var codeMirror, deferCodeMirror, onChange, options, opts;
          options = void 0;
          opts = void 0;
          onChange = void 0;
          deferCodeMirror = void 0;
          codeMirror = void 0;
          if (elm[0].type !== "textarea") {
            throw new Error("uiCodemirror3 can only be applied to a textarea element");
          }
          options = uiCodemirrorConfig.codemirror || {};
          opts = angular.extend({}, options, scope.$eval(attrs.uiCodemirror));
          onChange = function(aEvent) {
            return function(instance, changeObj) {
              var newValue;
              newValue = instance.getValue();
              if (newValue !== ngModel.$viewValue) {
                ngModel.$setViewValue(newValue);
                if (!scope.$$phase) {
                  scope.$apply();
                }
              }
              if (typeof aEvent === "function") {
                return aEvent(instance, changeObj);
              }
            };
          };
          deferCodeMirror = function() {
            var aEvent, i, n;
            codeMirror = CodeMirror.fromTextArea(elm[0], opts);
            codeMirror.on("change", onChange(opts.onChange));
            i = 0;
            n = events.length;
            aEvent = void 0;
            while (i < n) {
              aEvent = opts["on" + events[i].charAt(0).toUpperCase() + events[i].slice(1)];
              if (aEvent === void 0) {
                continue;
              }
              if (typeof aEvent !== "function") {
                continue;
              }
              codeMirror.on(events[i], aEvent);
              ++i;
            }
            ngModel.$formatters.push(function(value) {
              if (angular.isUndefined(value) || value === null) {
                return "";
              } else {
                if (angular.isObject(value) || angular.isArray(value)) {
                  throw new Error("ui-codemirror cannot use an object or an array as a model");
                }
              }
              return value;
            });
            ngModel.$render = function() {
              return codeMirror.setValue(ngModel.$viewValue);
            };
            if (attrs.uiRefresh) {
              return scope.$watch(attrs.uiRefresh, function(newVal, oldVal) {
                if (newVal !== oldVal) {
                  return $timeout(function() {
                    return codeMirror.refresh();
                  });
                }
              });
            }
          };
          return $timeout(deferCodeMirror);
        }
      };
    }
  ]);

}).call(this);
