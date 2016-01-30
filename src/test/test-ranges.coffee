Test = require 'tape'
Moment = require 'moment'
FormatUtils = require '../lib/utils'
Range  = require '../lib/range'

testRange = (t, type, yesno, range, contained) ->
	parseRangeFn = Range[type].parse
	parseFn = FormatUtils["parse#{type}"]
	_contained = if parseFn then parseFn.call(Range[type], contained) else contained
	_range = parseRangeFn.call(Range[type], range)
	t[yesno].call t, _range.containsDateTime(_contained),
		"#{type}Range: '#{contained}' #{if yesno is 'notOk' then 'not in' else 'in'} '#{range}'"
	return _range

Test 'parseWeekday', (t) ->
	t.equals typeof Range.Weekday.parseWeekday('Mo'), 'number', 'parseWeekday -> number'
	t.equals Range.Weekday.parseWeekday('Mo'), 1
	t.equals Range.Weekday.parseWeekday('Mon'), 1
	t.equals Range.Weekday.parseWeekday('Montag'), 1
	t.equals Range.Weekday.parseWeekday('Monday'), 1
	t.equals Range.Weekday.parseWeekday('Saturday'), 6
	t.equals Range.Weekday.parseWeekday(1), 1
	t.end()

Test 'parseDate', (t) ->
	t.toStringEquals = (a,b,msg) ->
		@equals(a.toString(), b.toString(), msg)
	t.ok FormatUtils.parseDate('2015-01-01') instanceof Moment, 'parseDate -> Moment'
	t.equals Range.Date.parse('2015-01-01').toString(), '2015-01-01', 'toString'
	t.equals Range.Date.parse('2015-01-01 daily 2015-01-10').toString(),
		'2015-01-01 daily 2015-01-10', 'toString'
	t.toStringEquals FormatUtils.parseDate('2015-01-01'), Moment('2015-01-01')
	t.toStringEquals FormatUtils.parseDate(Moment('2015-01-01')), Moment('2015-01-01')
	t.end()

Test 'parseTime', (t) ->
	t.toStringEquals = (a,b,msg) ->
		@equals(a.toString(), b.toString(), msg)
	t.ok FormatUtils.parseTime('08:10') instanceof Moment, 'parseTime -> Moment'
	t.equals Range.Time.parse('08:01-08:03').toString(), '08:01 - 08:03', 'toString'
	t.toStringEquals FormatUtils.parseTime('08:10'), Moment('08:10', 'H:m')
	t.end()

Test 'catchall ranges', (t) ->
	testRange t, 'Catchall', 'ok', 'foo', 'bar'
	t.end()

Test 'date ranges', (t) ->
	testRange t, 'Date', 'ok', '2000-01-01 - 2012-02-23', '2005-01-01'
	testRange t, 'Date', 'ok', '2000-01-01 -', '2005-01-01'
	testRange t, 'Date', 'ok', '2000-01-01', '2000-01-01'
	testRange t, 'Date', 'notOk', '2000-01-01', '2000-01-02'
	testRange t, 'Date', 'ok', '2000-01-01 weekly', '2000-01-08'
	testRange t, 'Date', 'ok', '2000-01-01 bi-weekly', '2000-01-15'
	testRange t, 'Date', 'ok', '2000-01-01 monthly', '2000-02-01'
	testRange t, 'Date', 'notOk', '2000-01-01 monthly 2000-02-24', '2000-03-01'
	testRange t, 'Date', 'ok', '2000-01-01 yearly', '2015-01-01'
	t.end()

Test 'time ranges', (t) ->
	testRange t, 'Time', 'ok', '1:00 - 8:00', '04:00'
	t.end()

Test 'weekday ranges', (t) ->
	testRange t, 'Weekday', 'ok', 'Mo', 'Mo'
	testRange t, 'Weekday', 'ok', 'Mo-So', 'Mi'
	testRange t, 'Weekday', 'ok', 'So-Mo', 'Mo'
	t.end()

Test 'named day ranges', (t) ->
	testRange t, 'NamedDay', 'ok', 'Heiligabend', '2016-12-24'
	t.end()

Test 'parseRanges', (t) ->
	t.ok Range.parseRanges('08:10-09:30,Mo')
	t.end()

Test.skip 'iterate 1', (t) ->
	range = testRange t, 'Date', 'ok', '2000-01-01 weekly 2012-02-23', '2005-01-01'
	max = 5
	i = 0
	range.iterate {by : 'month'}, (date) ->
		console.log date.toString()
	t.end()

Test 'iterate time', (t) ->
	timeRange = Range.Time.parse('08:00-16:00')
	onDate = timeRange.onDate(FormatUtils.parseDate('2015-01-01'))
	onDate.by 'hours', (date) ->
		console.log date.toString()
	# max = 5
	# i = 0
	# range.iterate {by :'month'}, (date) ->
	#     console.log date.toString()
	t.end()
