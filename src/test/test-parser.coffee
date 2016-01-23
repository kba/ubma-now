Moment = require 'moment'

Parser = require '../lib/parser'
DateRule   = require '../lib/date-rule'
TimeRule   = require '../lib/time-rule'

Test = require 'tape'

# console.log Parser.parseDate('2000-01-01')
Test 'date ranges', (t) ->
	t.ok Parser.parseDateRange('2000-01-01 - 2012-02-23').contains(Parser.parseDate('2005-01-01'))
	t.ok Parser.parseDateRange('2000-01-01 -').contains(Parser.parseDate('2005-01-01'))
	t.ok Parser.parseDateRange('2000-01-01').contains(Parser.parseDate('2000-01-01'))
	t.notOk Parser.parseDateRange('2000-01-01').contains(Parser.parseDate('2000-01-02'))
	timeRange = Parser.parseTimeRange('08:00 - 02:00')
	t.ok timeRange.contains(Parser.parseTime('08:30'))
	t.ok Parser.parseCriteria('Mo,Mi-Sun,*')
	t.end()

Test 'date-rule', (t) ->
	today = Moment().format('YYYY-MM-DD')
	weekday = Moment().format('dd')
	t.ok new DateRule("*", "08:00-02:00").match(Moment()), "Match '*'"
	t.ok new DateRule(today, "08:00-02:00").match(Moment()), "Match '#{today}'"
	t.ok new DateRule(weekday, "08:00-02:00").match(Moment()), "Match '#{weekday}'"
	t.end()

Test 'time-rule', (t) ->
	now = Moment().subtract(1, 'hours').format('HH:mm')
	now_plus_one = Moment().add(1, 'hours').format('HH:mm')
	t.ok new TimeRule("*", "08:00-02:00").match(Moment()), "Match '*'"
	t.ok new TimeRule("#{now}-#{now_plus_one}", "00:00-12:00").match(Moment()), "Match '#{now}'"
	t.end()
