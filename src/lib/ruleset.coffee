Range = require './range'
Rule = require './rule'
DeepMerge = require 'deep-extend'

module.exports = class Ruleset

	constructor : (@name, @rules) ->

	@fromRuleTree : (name, tree, options) ->
		options or= {}
		options.terminal or= open:true
		return new Ruleset(name, Rule.parseRuleTree(tree, options))

	applyDateTime: (date) ->
		ret = {}
		dataList = @rules.filter(
			(rule) -> rule.containsDateTime(date)
		).map((rule) ->
			ret = DeepMerge(ret, rule.data)
		)
		return ret
