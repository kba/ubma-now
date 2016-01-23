MomentRange = require 'moment-range'
Parser = require './parser'


module.exports = class DateRule

	match : (date) ->
		if Parser.CATCH_ALL in @criteria
			return true
		if date.day() in @criteria
			return true
		for c in @criteria
			return true if c instanceof MomentRange and c.contains(date)

	constructor: (criteria) ->
		@criteria = Parser.parseCriteria(criteria)
