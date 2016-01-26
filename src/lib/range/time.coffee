BaseRange = require './base'
Moment = require 'moment'
MomentRange = require 'moment-range'

log = require('easylog')(module)

TIME_REGEX = /\d{1,2}:\d{2}/
TIME_RANGE_REGEX = ///
	^
	(
		#{TIME_REGEX.source}
	)
	\s*-\s*
	(
		#{TIME_REGEX.source}
	)
	$
///

module.exports = class TimeRange extends BaseRange
	constructor : (from, to, repeat) ->
		@inheritMomentRange(from, to, ['contains', 'toString'])
	toString : ->
		return [@start, @end].map((date) -> date.format('HH:mm')).join(' - ')
	onDate : (date) ->
		date = TimeRange.parseTime(date)
		return Moment.range(
			Moment(date).hour(@start.hour()).minute(@start.minute())
			Moment(date).hour(@end.hour()).minute(@end.minute())
		)
	containsDate : -> true
	containsTime : (date) ->
		date = TimeRange.parseTime(date)
		return unless date
		range = @onDate(date)
		if range.contains(date)
			return true
	@parseTime : (time) ->
		if typeof time is 'string'
			return Moment(time, 'H:m')
		if time instanceof Moment
			return time
	@matchString : (str) -> TIME_RANGE_REGEX.test(str)
	@parse : (range) ->
		[from,to] = range.match(TIME_RANGE_REGEX).slice(1).map(TimeRange.parseTime)
		to.add(1, 'days') if to.isSameOrBefore(from)
		return new TimeRange(from, to)
