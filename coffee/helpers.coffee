extend = (obj, mixin) ->
  obj[name] = method for name, method of mixin        
  obj

include = (klass, mixin) ->
  extend klass.prototype, mixin

debuggerHelper = 
	debugMsg: (msg) ->
		return unless @debug
		console.log(msg)		