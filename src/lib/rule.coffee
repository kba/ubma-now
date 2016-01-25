Range = require './range'
Util = require 'util'

RULE_TYPES = ['and', 'or', 'xor']
Rule = module.exports = {}
Rule[ruleType] = require "./rule/#{ruleType}" for ruleType in RULE_TYPES

Rule.makeRule = (ruleType, ranges, data) ->
	ruleType = ruleType.toLowerCase()
	if ruleType not in RULE_TYPES
		throw new Error("No such rule type '#{ruleType}'. Must be one of [#{RULE_TYPES}]")
	return new Rule[ruleType](ranges, data)

_cloneArray = (arr, vals...) ->
	clone = []
	clone.push v for v in arr
	clone.push v for v in vals when v
	return clone

_scrapeData = (obj) ->
	if typeof obj is 'object'
		if Util.isArray obj
			arr = []
			data = []
			for v in obj
				if Range.matchString(v)
					arr.push v
				else
					data.push v
			return [arr, data]
		else
			data = {}
			Object.keys(obj).forEach (name) ->
				unless Range.matchString(name)
					data[name] = obj[name]
					delete obj[name]
			if Object.keys(data).length
				return [obj, data]
			return [obj]
	else
		if Range.matchString(obj)
			return [obj, true]
		else
			return [null, obj]

_parseRuleTree = (obj, parents, rules) ->
	[obj, data] = _scrapeData obj
	unless obj
		return rules.push {ranges: _cloneArray(parents), data: data}
	if typeof obj is 'object'
		if Util.isArray obj
			rules.push {ranges: _cloneArray(parents, v), data: true} for v in obj
			return
		else
			for name,child of obj
				_parseRuleTree(child, _cloneArray(parents, name), rules)
			if data
				return rules.push {ranges:_cloneArray(parents, name), data: data}
	else
		return rules.push {ranges: _cloneArray(parents, obj), data: data}
	return rules


Rule.parseRuleTree = (obj) ->
	return _parseRuleTree(obj, [], [])

###
'2015-01-01 - 2015-12-31':
	'Mo-Fr':
		08:00 - 12:00
		14:00 - 20:00
	'Sa':
		08:00 - 10:00
==>
[
	['and', '2015-01-01 - 2015-12-31,Mo-Fr,08:00 - 12:00']
	['and', '2015-01-01 - 2015-12-31,Mo-Fr,14:00 - 20:00']
	['and', '2015-01-01 - 2015-12-31,Sa,08:00 - 10:00']
]

###
