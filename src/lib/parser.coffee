Moment = require 'moment'
require 'moment-range'
class Parser

	@HOLIDAYS : 'holidays'
	@CATCH_ALL : '*'

	# TODO use Moment.localeData for this
	@WEEKDAY_MAP : {
		mo: 1, mon: 1, montag: 1,
		di: 2, die: 2, diensta: 2,
		mi: 3, mit: 3, mittwoch: 3,
		do: 4, don: 4, donnerstag: 4,
		fr: 5, fre: 5, freitag: 5,
		sa: 6, sam: 6, samstag: 6,
		so: 7, son: 7, sonntag: 7,
		monday: 1,
		tu: 2, tue: 2, tuesday: 2,
		we: 3, wed: 3, wednesday: 3,
		th: 4, thu: 4, thursday: 4,
		fri: 5, friday: 5,
		sat: 6, saturday: 6,
		su: 7, sun: 7, sunday: 7,
	}

	@parseDate: (date) -> Moment(date, 'YYYY-MM-DD')
	@parseDateRange: (range) ->
		dates = range.split(/\s+-\s*/)
		from = Parser.parseDate dates[0]
		if typeof dates[1] is 'undefined'
			to = Moment(from).add(1, 'days').subtract(1, 'second')
		else if dates[1] is ''
			to = null
		else
			to = Parser.parseDate dates[1]
		return Moment.range(from, to)

	@parseTime: (time) -> Moment(time, 'H:m')
	@parseTimeRange: (range) ->
		times = range.split(/\s*-\s*/)
		from = Parser.parseTime times[0]
		unless times[1]
			throw new Error("Invalid time range: #{range}")
		to = Parser.parseTime times[1]
		to.add(1, 'days') if to.isSameOrBefore(from)
		return Moment.range(from, to)

	@parseCriteria: (criteria) ->
		criteria = criteria.toLowerCase().replace(/\s*/g, '')
		tokens = []
		criteria.split(/,/).forEach (v) ->
			if /^\d{2}:\d{2}/.test v
				return tokens.push Parser.parseTimeRange(v)
			if /^\d{4}-\d{2}-\d{2}/.test v
				return tokens.push Parser.parseDateRange(v)
			range = v.split('-', 2).map (vv) ->
				if vv is Parser.CATCH_ALL
					return Parser.CATCH_ALL
				else if vv of Parser.WEEKDAY_MAP
					return Parser.WEEKDAY_MAP[vv]
				else
					throw new Error("Unknown token #{vv}")
			if range.length >= 2
				tokens.push expanded for expanded in [range[0] .. range[1]]
			else
				tokens.push range[0]
		return tokens

module.exports = Parser
