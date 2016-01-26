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
	constructor: (from, to, repeat) ->
		@inheritMomentRange(from, to, ['contains', 'toString'])
	toString : ->
		return [@_range.start, @_range.end].map((date) -> date.format('HH:mm')).join(' - ')
	contains : (date) ->
		date = TimeRange.parseTime(date)
		return unless date
		if @_range.contains Moment(@_range.start).hour(date.hour()).minute(date.minute())
			return true
	@parseTime: (time) ->
		if typeof time is 'string'
			return Moment(time, 'H:m')
		if time instanceof Moment
			return time
	@matchString: (str) -> TIME_RANGE_REGEX.test(str)
	@parse: (range) ->
		[from,to] = range.match(TIME_RANGE_REGEX).slice(1).map(TimeRange.parseTime)
		to.add(1, 'days') if to.isSameOrBefore(from)
		return new TimeRange(from, to)
