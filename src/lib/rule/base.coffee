Range = require '../range'

module.exports = class BaseRule

	constructor: (@ranges, @data) ->
		if typeof @ranges == 'string'
			@ranges = Range.parseRanges(@ranges)
