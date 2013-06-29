angular.module("ui.codemirror", [])
       .constant("uiCodemirrorConfig", {})
       .directive "uiCodemirror", ["uiCodemirrorConfig", "$timeout", (uiCodemirrorConfig, $timeout) ->
  "use strict"
  events = ["cursorActivity", "viewportChange", "gutterClick", "focus", "blur", "scroll", "update"]
  restrict: "A"
  require: "ngModel"
  link: (scope, elm, attrs, ngModel) ->
    options = undefined
    opts = undefined
    onChange = undefined
    deferCodeMirror = undefined
    codeMirror = undefined
    throw new Error("uiCodemirror3 can only be applied to a textarea element")  if elm[0].type isnt "textarea"
    options = uiCodemirrorConfig.codemirror or {}
    opts = angular.extend({}, options, scope.$eval(attrs.uiCodemirror))
    onChange = (aEvent) ->
      (instance, changeObj) ->
        newValue = instance.getValue()
        if newValue isnt ngModel.$viewValue
          ngModel.$setViewValue newValue
          scope.$apply()  unless scope.$$phase
        aEvent instance, changeObj  if typeof aEvent is "function"

    deferCodeMirror = ->
      codeMirror = CodeMirror.fromTextArea(elm[0], opts)
      codeMirror.on "change", onChange(opts.onChange)
      i = 0
      n = events.length
      aEvent = undefined

      while i < n
        aEvent = opts["on" + events[i].charAt(0).toUpperCase() + events[i].slice(1)]
        continue  if aEvent is undefined
        continue  if typeof aEvent isnt "function"
        codeMirror.on events[i], aEvent
        ++i
      
      # CodeMirror expects a string, so make sure it gets one.
      # This does not change the model.
      ngModel.$formatters.push (value) ->
        if angular.isUndefined(value) or value is null
          return ""
        else throw new Error("ui-codemirror cannot use an object or an array as a model")  if angular.isObject(value) or angular.isArray(value)
        value

      
      # Override the ngModelController $render method, which is what gets called when the model is updated.
      # This takes care of the synchronizing the codeMirror element with the underlying model, in the case that it is changed by something else.
      ngModel.$render = ->
        codeMirror.setValue ngModel.$viewValue

      
      # Watch ui-refresh and refresh the directive
      if attrs.uiRefresh
        scope.$watch attrs.uiRefresh, (newVal, oldVal) ->
          
          # Skip the initial watch firing
          if newVal isnt oldVal
            $timeout ->
              codeMirror.refresh()

    $timeout deferCodeMirror
]