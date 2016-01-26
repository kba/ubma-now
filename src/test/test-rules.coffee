Test = require 'tape'
Moment = require 'moment'
DUMP = (arg) -> console.log require('util').inspect(arg, {colors:true, depth: 3})

Rule  = require '../lib/rule'

testRule = (t, yesno, type, range, contained) ->
	rule = Rule.makeRule(type, range)
	t[yesno].apply t, [rule.contains(contained),
		"#{contained.toString()} '#{if yesno then 'in' else 'not in'}' (#{rule.toString()})"]

Test 'or-rule', (t) ->
	testRule t, 'ok', 'OR', 'Mo-So', 'Di'
	t.end()

Test 'and-rule', (t) ->
	testRule t, 'ok', 'AND', 'Mo,08:00-09:00', Moment('2016-01-25 08:30:00')
	t.end()

Test 'tree', (t) ->
	tree =
		'2015-01-01 - 2015-12-31':
			'Mo-Fr,Di': [
				"08:00 - 12:00"
				"14:00 - 20:00"
			]
			'Sa':
				"08:00 - 10:00"

	rules = Rule.parseRuleTree(tree, {terminal: open:true})
	# DUMP rules
	# DUMP rules[0].contains(Moment('2015-11-09T09:00Z'))
	# DUMP rules[0].toString()
	t.end()


