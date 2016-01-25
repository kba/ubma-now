BaseRange = require './base'
Moment = require 'moment'
MomentRange = require 'moment-range'

DATE_REPEATS = [ '-','daily','weekly','bi-weekly','monthly','yearly' ]

DATE_REGEX = /\d{4}-\d{2}-\d{2}/

DATE_RANGE_REGEX = ///
	^
	(
		#{DATE_REGEX.source}
	)
	(?:
		\s+
		(
			#{DATE_REPEATS.join('|')}
		)
		(?:
			\s+
			(
				#{DATE_REGEX.source}
			)
		)?
	)?
	\s*
	$
///

module.exports = class DateRange extends BaseRange
	constructor: (from, to, @repeat) ->
		@inheritMomentRange(from, to, ['contains', 'toString'])
		@repeat or= 'daily'
	toString : ->
		[from,to] = [@_range.start, @_range.end].map((date) -> date.format('YYYY-MM-DD'))
		if from == to
			return from
		else
			return [from,to].join(" #{@repeat} ")
	contains: (date) ->
		date = DateRange.parseDate(date)
		return unless @_range.contains(date)
		return true if @repeat is 'daily'
		daysSince = date.diff(@_range.start, 'days')
		if @repeat is 'weekly'
			return true if daysSince % 7 == 0
		else if @repeat is 'bi-weekly'
			return true if daysSince % 14 == 0
		else if @repeat is 'monthly'
			return true if @_range.start.date() == date.date()
		else if @repeat is 'yearly'
			return true if(
				@_range.start.date() == date.date() and
				@_range.start.month() == date.month()
			)
	@parseDate: (date) ->
		if typeof date is 'string'
			return Moment(date, 'YYYY-MM-DD')
		if date instanceof Moment
			return date
	@matchString: (str) -> DATE_RANGE_REGEX.test(str)
	@parse: (range) ->
		[from, repeat, to] = range.match(DATE_RANGE_REGEX).slice(1)
		from = DateRange.parseDate(from).hour(0).minute(0).second(0)
		unless repeat
			to = Moment(from).hour(23).minute(59).second(59)
		else if repeat == '-'
			repeat = 'daily'
		if to
			to = DateRange.parseDate to
		return new DateRange(from, to, repeat)


