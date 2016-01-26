Moment = require 'moment'
module.exports = class BaseRange
	inheritMomentRange : (from, to, excludeMethods)->
		excludeMethods or= ['toString']
		@_range = Moment.range(from, to)
		@[k] = v for k,v of @_range when k not in excludeMethods

	containsDate : -> throw new Error("'containsDate' not implemented for '#{@constructor.name}'")
	containsTime : -> throw new Error("'containsTime' not implemented for '#{@constructor.name}'")
	containsDateTime : (date) -> @containsDate(date) and @containsTime(date)
	iterate : -> throw new Error("'iterate' not implemented for '#{@constructor.name}'")
	toString : -> throw new Error("'toString' not implemented for '#{@constructor.name}'")
