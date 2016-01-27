Moment = require 'moment'
Range = require '../range'
Utils = require '../utils'

log = require('easylog')(module)

module.exports = class BaseRule

	dateCache: {}
	timeCache: {}
	dateTimeCache: {}

	constructor : (@ranges, @data) ->
		# @cache = {}
		# for type in ['Date', 'Time', 'DateTime']
		#     @cache[type] = {}
		#     @["for#{type}"]
		#
	containsDate : (date) -> return @_containsDate date
	containsTime : (date) -> return @_containsTime date
	containsDateTime : (date) -> return @_containsDate(date) and @_containsTime(date)

	# containsDate : (date) ->
	#     unless date instanceof Moment
	#         throw new Error("Must be a moment, not #{date}")
	#     needle = Utils.formatDate(date)
	#     @dateCache[needle] or= @_containsDate date
	#     return @dateCache[needle]

	# containsTime : (date) ->
	#     unless date instanceof Moment
	#         throw new Error("Must be a moment, not #{date}")
	#     needle = Utils.formatTime(date)
	#     @timeCache[needle] or= @_containsTime date
	#     return @timeCache[needle]

	# containsDateTime : (date) ->
	#     unless date instanceof Moment
	#         throw new Error("Must be a moment, not #{date}")
	#     needle = Utils.formatDateTime(date)
	#     @dateTimeCache[needle] or= @_containsDate date and @_containsTime date
	#     return @dateTimeCache[needle]

	toString : ->
		op = @constructor.name.replace('Rule', '').toUpperCase()
		ret = @ranges.map((range) ->
			"(#{range.toString()})"
		).join(" #{op} ")
		ret += " => #{JSON.stringify @data}" if @data
		return ret
