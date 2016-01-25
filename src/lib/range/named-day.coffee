Moment = require 'moment'
MomentRange = require 'moment-range'
DateRange = require './date'
CONFIG = require '../config'

DEFAULT_LIST = 'holidays'

NAMED_DAY_REGEX = ///
	^
	\s*
	(?:
		(
			[a-zA-Z][a-zA-Z0-9_-]+
		)
		:
	)?
	\s*
	(
		[^\s].*
	)
	\s*
	$
///

module.exports = class NamedDayRange extends DateRange
	constructor: (from, to, repeat, @prefix, @name) ->
		super
	toString : ->
		tokens = []
		tokens.push @prefix
		tokens.push @name
		return tokens.join(':')
	@matchString: (str) ->
		return unless NAMED_DAY_REGEX.test(str)
		[prefix, name] = str.match(NAMED_DAY_REGEX).slice(1)
		if prefix and prefix not of CONFIG.NAMED_DAYS
			return false
		prefix or= CONFIG.DEFAULT_NAMED_DAYS
		if name and name not of CONFIG.NAMED_DAYS[prefix]
			return false
		unless DateRange.matchString CONFIG.NAMED_DAYS[prefix][name]
			throw new Error("Invalid date range for #{prefix}:#{name} :" +
				"'#{CONFIG.NAMED_DAYS[prefix][name]}'")
		return true
	@parse: (str) ->
		[prefix, name] = str.match(NAMED_DAY_REGEX).slice(1)
		prefix or= CONFIG.DEFAULT_NAMED_DAYS
		range = CONFIG.NAMED_DAYS[prefix][name]
		dateRange = DateRange.parse(range)
		return new NamedDayRange(
			dateRange._range.start
			null
			dateRange._range.repeat
			prefix
			name
		)



