BaseRule = require './base'

log = require('easylog')(module)

module.exports = class AndRule extends BaseRule

	containsDate : (date) ->
		@ranges.every (range) ->
			log.debug "#{range.toString()} containsDate #{date.toString()}: #{range.containsDate(date)}"
			range.containsDate(date)

	containsTime : (date) ->
		@ranges.every (range) ->
			log.debug "#{range.toString()} containsTime #{date.toString()}: #{range.containsTime(date)}"
			range.containsTime(date)

	containsDateTime : (date) ->
		@ranges.every (range) ->
			log.debug "#{range.toString()} containsDateTime #{date.toString()}: #{range.containsDateTime(date)}"
			range.containsDateTime(date)
