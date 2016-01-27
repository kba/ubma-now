BaseRule = require './base'

module.exports = class OrRule extends BaseRule

	_containsDate : (date) ->
		@ranges.some (range) ->
			log.debug "#{range.toString()} containsDate #{date.toString()}: #{range.containsDate(date)}"
			range.containsDate(date)

	_containsTime : (date) ->
		@ranges.some (range) ->
			log.debug "#{range.toString()} containsTime #{date.toString()}: #{range.containsTime(date)}"
			range.containsTime(date)
