module.exports = class Hours

	constructor : (@validRange, @timeRules) ->

	forDate : (date) ->
		unless @dateRange.contains(date)
			return 'MEEEP'

	forDateTime : (dateTime) ->
