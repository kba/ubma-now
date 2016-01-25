BaseRule = require './base'

module.exports = class AndRule extends BaseRule

	contains: (date) ->
		@ranges.every (range) ->
			range.contains(date)
