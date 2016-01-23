MomentRange = require 'moment-range'
Moment      = require 'moment'
Parser = require './parser'

module.exports = class TimeRule

	match : (date) ->
		if Parser.CATCH_ALL in @criteria
			return true
		for c in @criteria
			if c instanceof MomentRange
				return true if c.contains Moment(c).hour(date.hour()).minute(date.minute())

	constructor: (criteria) ->
		@criteria = Parser.parseCriteria(criteria)
