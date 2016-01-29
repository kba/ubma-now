BaseRule = require './base-rule'

log = require('easylog')(module)

module.exports = class AndRule extends BaseRule

	_containsDate : (date) ->
		@ranges.every (range) ->
			log.silly "#{range.toString()} containsDate #{date.toString()}: #{range.containsDate(date)}"
			range.containsDate(date)

	_containsTime : (date) ->
		@ranges.every (range) ->
			log.silly "#{range.toString()} containsTime #{date.toString()}: #{range.containsTime(date)}"
			range.containsTime(date)
