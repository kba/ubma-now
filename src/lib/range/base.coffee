Moment = require 'moment'
module.exports = class BaseRange
	inheritMomentRange: (from, to, excludeMethods)->
		excludeMethods or= []
		@_range = Moment.range(from, to)
		@[k] = v for k,v of @_range when k not in excludeMethods
	contains: -> throw new Error("'contains' not implemented")
	iterate: -> throw new Error("'iterate' not implemented")
