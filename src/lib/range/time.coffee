BaseRange = require './base-range'
Moment = require 'moment'
MomentRange = require 'moment-range'
FormatUtils = require '../utils'

log = require('easylog')(module)

TIME_RANGE_REGEX = ///
	^
	(
		#{FormatUtils.Regex.Time.source}
	)
	\s*-\s*
	(
		#{FormatUtils.Regex.Time.source}
	)
	$
///

module.exports = class TimeRange extends BaseRange
	constructor : (from, to, repeat) ->
		@inheritMomentRange(from, to, ['contains', 'toString'])
	toString : ->
		return [@start, @end].map((date) -> date.format('HH:mm')).join(' - ')
	onDate : (date) ->
		date = FormatUtils.parseTime(date)
		return Moment.range(
			Moment(date).hour(@start.hour()).minute(@start.minute())
			Moment(date).hour(@end.hour()).minute(@end.minute())
		)
	containsDate : -> true
	containsTime : (date) ->
		date = FormatUtils.parseTime(date)
		return unless date
		range = @onDate(date)
		if range.contains(date)
			return true
	@matchString : (str) -> TIME_RANGE_REGEX.test(str)
	@parse : (range) ->
		[from,to] = range.match(TIME_RANGE_REGEX).slice(1).map(FormatUtils.parseTime)
		to.add(1, 'days') if to.isSameOrBefore(from)
		return new TimeRange(from, to)
