Util = require 'util'
DeepMerge = require 'deep-extend'

Range = require './range'
Rule = require './rule'

RULESET_TYPES = ['OpeningHours']

log = require('easylog')(module)

Ruleset = module.exports = {}
for type in RULESET_TYPES
	modName = type.replace(/(?!^)[A-Z]/, (v) -> "-#{v}").toLowerCase()
	Ruleset[type] = require "./ruleset/#{modName}"

Ruleset.fromRuleTree = (type, name, tree, options) ->
	rulesetClass = Ruleset[type]
	options or= {}
	options[k] or= v for k,v of rulesetClass.defaultOptions
	parsed = Ruleset.parseRuleTree(tree, options)
	return new rulesetClass(name, parsed, tree, options)

_cloneArray = (arr, vals...) ->
	clone = []
	clone.push v for v in arr
	clone.push v for v in vals when v
	return clone

_scrapeData = (obj, options) ->
	if typeof obj is 'object'
		if Util.isArray obj
			arr = []
			data = []
			for v in obj
				if Range.matchStrings(v)
					arr.push v
				else
					data.push v
			return [arr, data]
		else
			data = {}
			log.info [obj, data]
			Object.keys(obj).forEach (name) ->
				unless Range.matchStrings(name)
					data[name] = obj[name]
					delete obj[name]
			obj = null unless Object.keys(obj).length
			return [obj, data] if Object.keys(data).length
			return [obj]
	else
		if Range.matchStrings(obj)
			return [obj, options.terminal]
		else
			return [null, obj]

_parseRuleTree = (obj, parents, rules, options) ->
	[obj, data] = _scrapeData obj, options
	unless obj
		return rules.push {ranges : _cloneArray(parents), data : data}
	if typeof obj is 'object'
		if Util.isArray obj
			# rules.push {ranges : _cloneArray(parents, v), data : true} for v in obj
			_parseRuleTree(v, _cloneArray(parents), rules, options) for v in obj
			return
		else
			for name,child of obj
				log.debug "OBJECT: #{name}", child
				_parseRuleTree(child, _cloneArray(parents, name), rules, options)
				if data
					rules.push {ranges : _cloneArray(parents), data : data}
	else
		return rules.push {ranges : _cloneArray(parents, obj), data : data}
	return rules


###
'*':
	foo: 42
'2015-01-01 - 2015-12-31':
	'Mo-Fr':
		08:00 - 12:00
		14:00 - 20:00
	'Sa':
		08:00 - 10:00
==>
[
	['and', '*', {foo: 42}]
	['and', '2015-01-01 - 2015-12-31,Mo-Fr,08:00 - 12:00', true]
	['and', '2015-01-01 - 2015-12-31,Mo-Fr,14:00 - 20:00', true]
	['and', '2015-01-01 - 2015-12-31,Sa,08:00 - 10:00', true]
]

###
Ruleset.parseRuleTree = (obj, options={}) ->
	options.terminal or= true
	andRules = _parseRuleTree(obj, [], [], options)
	rules = andRules.map (andRule) -> [
		'and',
		andRule.ranges.map (ranges) -> ['or', ranges.split(/\s*,\s*/)]
		andRule.data
	]
	return rules if options.parseOnly
	rules.map (andRule) ->
		andRule[1] = andRule[1].map (orRule) ->
			# console.log orRule
			Rule.makeRule.apply(Rule, orRule)
		andRule = Rule.makeRule.apply(Rule, andRule)
		andRule
