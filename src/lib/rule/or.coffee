BaseRule = require './base'

module.exports = class OrRule extends BaseRule

	contains: (date) ->
		@ranges.some (range) -> range.contains(date)

