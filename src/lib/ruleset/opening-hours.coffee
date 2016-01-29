Rule = require '../rule'
BaseRuleset = require './base-ruleset'

module.exports = class OpeningHoursRuleset extends BaseRuleset

	@defaultOptions : {
		terminal :
			open : true
	}
