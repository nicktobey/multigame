exports = exports ? this

global = (name, data) ->
	exports[name] = data
	
global "global", global