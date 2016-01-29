Moment = require 'moment'
BaseRange = require './base-range'
CONFIG = require '../config'

module.exports = class WeekdayRange extends BaseRange
	constructor : (@weekdays=[]) ->
	containsTime : -> true
	containsDate : (day) -> return WeekdayRange.parseWeekday(day) in @weekdays
	@parseWeekday : (weekday) ->
		if typeof weekday is 'string'
			return CONFIG.WEEKDAY_MAP[weekday.toLowerCase()]
		if typeof weekday is 'number'
			return weekday if weekday in [0 .. 7]
		if weekday instanceof Moment
			return weekday.day()
	@matchString : (str) ->
		str.split(/\s*-\s*/).every (v) -> v of CONFIG.WEEKDAY_MAP
	toString : -> @weekdays.map(
		(number) -> Moment.localeData().weekdaysMin(Moment(number, 'e'))).join(',')
	@parse : (str) ->
		tokens = []
		str = str.toLowerCase()
		range = str.split('-', 2).map (day) -> WeekdayRange.parseWeekday(day)
		if range.length >= 2
			if range[1] < range[0]
				i = range[0]
				while i != range[1]
					tokens.push i++
					i = 0 if i % 7 == 0
				tokens.push i
			else
				tokens.push expanded for expanded in [range[0] .. range[1]]
		else
			tokens.push range[0]
		return new WeekdayRange(tokens)
