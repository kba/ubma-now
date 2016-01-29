BaseRange = require './base-range'
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

module.exports = class NamedDayRange extends BaseRange
	constructor : (@prefix, @name, @ranges) ->
	toString : ->
		tokens = []
		tokens.push @prefix
		tokens.push @name
		return tokens.join(':')
	containsTime : -> true
	containsDate : (date) ->
		@ranges.some (range) -> range.containsDate(date)
	@matchString : (str) ->
		return unless NAMED_DAY_REGEX.test(str)
		[prefix, name] = str.match(NAMED_DAY_REGEX).slice(1)
		if prefix and prefix not of CONFIG.NAMED_DAYS
			return false
		prefix or= CONFIG.DEFAULT_NAMED_DAYS
		if name and name not of CONFIG.NAMED_DAYS[prefix]
			return false
		ranges = CONFIG.NAMED_DAYS[prefix][name]
		for range in ranges.split(/\s*,\s*/)
			unless DateRange.matchString range
				throw new Error("Invalid date range for #{prefix}:#{name} : '#{range}'")
		return true
	@parse : (str) ->
		[prefix, name] = str.match(NAMED_DAY_REGEX).slice(1)
		prefix or= CONFIG.DEFAULT_NAMED_DAYS
		ranges = []
		rangesStr = CONFIG.NAMED_DAYS[prefix][name]
		for range in rangesStr.split(/\s*,\s*/)
			dateRange = DateRange.parse(range)
			ranges.push dateRange
		return new NamedDayRange(prefix, name, ranges)
