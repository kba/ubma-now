Range = require './range'

log = require('easylog')(module)

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
	return new Rule[ruleType](ranges, data)
