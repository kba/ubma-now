Moment = require 'moment'
MomentRange = require 'moment-range'
CONFIG = require './config'
RANGE_TYPES = ['Catchall', 'Weekday', 'NamedDay', 'Date', 'Time']

Range = module.exports = {}
for type in RANGE_TYPES
	modName = type.replace(/(?!^)[A-Z]/, (v) -> "-#{v}").toLowerCase()
	Range[type] = require "./range/#{modName}"

Range.matchString = (range) ->
	return unless typeof range is 'string'
	range = range.toLowerCase().trim()
	for type in RANGE_TYPES
		if Range[type].matchString(range)
			return type

Range.parseRange = (range) ->
	range = range.toLowerCase().trim()
	type = Rane.matchString(range)
	if type
		return Range[type].parse(range)
	throw new Error("Could not determine range type for '#{range}'")

Range.parseRanges = (ranges) -> ranges.split(/\s*,\s*/).map Range.parseRange
