Range = require './range'
Rule = require './rule'
DeepMerge = require 'deep-extend'

module.exports = class Ruleset

	constructor : (@name, @rules) ->

	apply: (date) ->
		ret = {}
		dataList = @rules.filter(
			(rule) -> rule.containsDateTime(date)
		).map((rule) ->
			ret = DeepMerge(ret, rule.data)
		)
		return ret
