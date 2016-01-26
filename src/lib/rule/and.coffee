BaseRule = require './base'

log = require('easylog')(module)

module.exports = class AndRule extends BaseRule

	contains : (date) ->
		@ranges.every (range) ->
			log.debug "#{range.toString()} contains #{date.toString()}: #{range.contains(date)}"
			range.contains(date)
