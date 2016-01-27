Test = require 'tape'
Moment = require 'moment'
DUMP = (arg) -> console.log require('util').inspect(arg, {colors:true, depth: 3})

Rule  = require '../lib/rule'

testRule = (t, yesno, type, range, contained) ->
	rule = Rule.makeRule(type, range)
	t[yesno].apply t, [
		rule.containsDateTime(contained),
		"#{contained.toString()} '#{if yesno then 'in' else 'not in'}' (#{rule.toString()})"
	]

Test 'or-rule', (t) ->
	testRule t, 'ok', 'OR', 'Mo-So', 'Di'
	t.end()

Test 'and-rule', (t) ->
	testRule t, 'ok', 'AND', ['Mo','08:00-09:00'], Moment('2016-01-25 08:30:00')
	t.end()

Test 'data', (t) ->
	rule1 = Rule.makeRule('and', '08:00 - 09:00')
	console.log rule1.containsTime('09:30')
	t.end()

