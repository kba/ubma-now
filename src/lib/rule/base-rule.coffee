Moment = require 'moment'
Range = require '../range'
FormatUtils = require '../utils'

log = require('easylog')(module)

module.exports = class BaseRule

	cache : {}

	_containsDateTime : (date) ->
		@containsDate(date) and @containsTime(date)

	constructor : (@ranges, @data) ->
		FormatUtils.Type.forEach (type) =>
			@cache[type] = {}
			@["contains#{type}"] or= (date) =>
				date = FormatUtils["parse#{type}"].apply(FormatUtils, [date])
				# unless date.toString() of @cache[type]
				match = @["_contains#{type}"].apply(@, [date])
				return match
					# @cache[type][date.toString()] = match
				# return @cache[type][date.toString()]

	toString : ->
		op = @constructor.name.replace('Rule', '').toUpperCase()
		ret = @ranges.map((range) ->
			"(#{range.toString()})"
		).join(" #{op} ")
		ret += " => #{JSON.stringify @data}" if @data
		return ret

	filterRanges : (fn) ->
		ret = []
		@ranges.map (range) ->
			if fn(range)
				ret.push range
			if range.filterRanges
				ret.push v for v in range.filterRanges(fn)
		return ret
