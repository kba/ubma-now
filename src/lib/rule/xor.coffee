BaseRule = require './base-rule'

module.exports = class XorRule extends BaseRule

	_containsDate : (date) ->
		@ranges.filter((range) -> range.containsDate(date)).length == 1

	_containsTime : (date) ->
		@ranges.filter((range) -> range.containsTime(date)).length == 1
