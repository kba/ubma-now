BaseRule = require './base'

module.exports = class XorRule extends BaseRule

	contains : (date) ->
		@ranges.filter((range) -> range.contains(date)).length == 1
