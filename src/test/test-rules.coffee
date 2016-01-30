Test = require 'tape'
Moment = require 'moment'
DUMP = (arg) -> console.log require('util').inspect(arg, {colors : true, depth : 3})

Rule  = require '../lib/rule'
Range = require '../lib/range'

testRule = (t, yesno, type, range, contained) ->
	rule = Rule.makeRule(type, range)
	t[yesno].apply t, [
		rule.containsDateTime(contained),
		"#{contained.toString()} '#{if yesno then 'in' else 'not in'}' (#{rule.toString()})"
	]

Test 'or-rule', (t) ->
	testRule t, 'ok', 'OR', 'Mo-So', Moment('2016-01-25 08:30:00')
	t.end()

Test 'and-rule', (t) ->
	testRule t, 'ok', 'AND', ['Mo','08:00-09:00'], Moment('2016-01-25 08:30:00')
	t.end()

Test 'containsTime', (t) ->
	rule1 = Rule.makeRule('and', '08:00 - 09:00')
	t.ok rule1.containsTime('08:30')
	t.end()

Test 'filterRanges', (t) ->
	rule1 = Rule.makeRule('and', ['So', 'Fr', '08:00 - 09:00'])
	t.equals rule1.filterRanges((range) -> range instanceof Range.Time).length, 1
	t.end()
