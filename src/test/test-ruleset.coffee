Test = require 'tape'
Moment = require 'moment'
DUMP = (arg) -> console.log require('util').inspect(arg, {colors:true, depth: 3})


RuleSet  = require '../lib/ruleset'
Rule  = require '../lib/rule'

tree1 =
	'*':
		foo: 42
	'2016-01-01 - 2016-12-31':
		'Mo-Fr,Di': [
			"08:00 - 12:00"
			"13:00 - 20:00"
		]
		'Sa':
			"08:00 - 10:00" 

Test 'tree', (t) ->
	rules = Rule.parseRuleTree(tree1, {terminal: {open:true}})
	t.equals rules.length, 4, 'all rules were parsed'
	t.equals rules.filter((r)->r.data).length, 4, 'all rules have data'
	ruleset = new RuleSet('a3', rules)
	ruleset.apply(Moment())
	# DUMP rules
	# DUMP rules[0].contains(Moment('2015-11-09T09:00Z'))
	# DUMP rules[0].toString()
	t.end()

