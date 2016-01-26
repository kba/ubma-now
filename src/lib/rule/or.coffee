BaseRule = require './base'

module.exports = class OrRule extends BaseRule

	containsDate : (date) ->
		@ranges.some (range) ->
			log.debug "#{range.toString()} containsDate #{date.toString()}: #{range.containsDate(date)}"
			range.containsDate(date)

	containsTime : (date) ->
		@ranges.some (range) ->
			log.debug "#{range.toString()} containsTime #{date.toString()}: #{range.containsTime(date)}"
			range.containsTime(date)

	containsDateTime : (date) ->
		@ranges.some (range) ->
			log.debug "#{range.toString()} containsDateTime #{date.toString()}: #{range.containsDateTime(date)}"
			range.containsDateTime(date)
