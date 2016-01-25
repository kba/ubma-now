Range = require '../range'

module.exports = class BaseRule

	constructor: (@ranges, @data) ->
		if typeof @ranges == 'string'
			@ranges = Range.parseRanges(@ranges)
		@ranges = @ranges.map (range) ->
			if typeof range == 'string'
				range = Range.parseRange(range)
			range

	toString: ->
		op = @constructor.name.replace('Rule', '').toUpperCase()
		@ranges.map((range) ->
			"(#{range.toString()})"
		).join(" #{op} ")
