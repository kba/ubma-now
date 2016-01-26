Moment = require 'moment'
module.exports = class BaseRange
	inheritMomentRange: (from, to, excludeMethods)->
		excludeMethods or= ['toString']
		@_range = Moment.range(from, to)
		@[k] = v for k,v of @_range when k not in excludeMethods

	contains: -> throw new Error("'contains' not implemented for '#{@constructor.name}'")
	iterate:  -> throw new Error("'iterate' not implemented for '#{@constructor.name}'")
	toString: -> throw new Error("'toString' not implemented for '#{@constructor.name}'")
