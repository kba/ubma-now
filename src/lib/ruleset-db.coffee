FormatUtils = require './utils'
Ruleset  = require './ruleset'

module.exports = class RulesetDB

	db : {}

	put : (type, name, tree) ->
		@db[name] = Ruleset.fromRuleTree(type, name, tree)

	get : (name) -> @db[name]

	find : (category, date, options) ->
		parseMethod = "parse#{category}"
		applyMethod = "apply#{category}"
		ret = {}
		moment = FormatUtils[parseMethod].apply FormatUtils, [date]
		Object.keys(@db).map (name) =>
			ret[name] = @db[name][applyMethod].apply(@db[name], [moment])
		return ret
