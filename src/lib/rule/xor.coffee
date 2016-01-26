BaseRule = require './base'

module.exports = class XorRule extends BaseRule

	containsDate : (date) ->
		@ranges.filter((range) -> range.containsDate(date)).length == 1

	containsTime : (date) ->
		@ranges.filter((range) -> range.containsTime(date)).length == 1

	containsDateTime : (date) ->
		@ranges.filter((range) -> range.containsDateTime(date)).length == 1
