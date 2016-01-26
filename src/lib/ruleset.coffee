module.exports = class Ruleset

	constructor : (@timeRules) ->

	onDate : (date) ->
		unless @dateRange.contains(date)
			return 'MEEEP'

	onDateTime : (dateTime) ->
