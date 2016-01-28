RuleSet  = require '../lib/ruleset'

module.exports = class Place

	constructor : (@name, @tree) ->
		rules = Rule.parseRuleTree(@tree, {
			terminal: {open:true}
		})
		@ruleset = new RuleSet(@name, rules)
