Range = require './range'
Util = require 'util'

RULE_TYPES = ['and', 'or', 'xor']
Rule = module.exports = {}
Rule[ruleType] = require "./rule/#{ruleType}" for ruleType in RULE_TYPES

Rule.makeRule = (ruleType, ranges, data) ->
	ruleType = ruleType.toLowerCase()
	if ruleType not in RULE_TYPES
		throw new Error("No such rule type '#{ruleType}'. Must be one of [#{RULE_TYPES}]")
	if typeof ranges == 'string'
		ranges = Range.parseRanges(ranges)
	ranges = ranges.map (range) ->
		if typeof range == 'string'
			range = Range.parseRange(range)
		return range
	if ranges.length == 1
		return ranges[0]
	return new Rule[ruleType](ranges, data)

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
			Object.keys(obj).forEach (name) ->
				unless Range.matchStrings(name)
					data[name] = obj[name]
					delete obj[name]
			if Object.keys(data).length
				return [obj, data]
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
				_parseRuleTree(child, _cloneArray(parents, name), rules, options)
			if data
				return rules.push {ranges : _cloneArray(parents, name), data : data}
	else
		return rules.push {ranges : _cloneArray(parents, obj), data : data}
	return rules


Rule.parseRuleTree = (obj, options={}) ->
	options.terminal or= true
	andRules = _parseRuleTree(obj, [], [], options)
	rules = andRules.map (andRule) -> [
		'and',
		andRule.ranges.map (ranges) -> ['or', ranges.split(/\s*,\s*/)]
		andRule.data
	]
	rules.map (andRule) ->
		andRule[1] = andRule[1].map (orRule) ->
			if orRule[1].length > 1
				Rule.makeRule.apply(Rule, orRule)
			else
				console.log orRule[1][0]
				Range.parseRange(orRule[1][0])
		Rule.makeRule.apply(Rule, andRule)

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
