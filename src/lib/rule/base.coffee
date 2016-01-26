Range = require '../range'

module.exports = class BaseRule

	constructor: (@ranges, @data) ->

	toString: ->
		op = @constructor.name.replace('Rule', '').toUpperCase()
		@ranges.map((range) ->
			"(#{range.toString()})"
		).join(" #{op} ")
