Moment = require 'moment'
MomentRange = require 'moment-range'
CONFIG = require './config'
RANGE_TYPES = ['Catchall', 'Weekday', 'NamedDay', 'Date', 'Time']

log = require('easylog')(module)

matchCache = {}
parseCache = {}

Range = module.exports = {}
for type in RANGE_TYPES
	modName = type.replace(/(?!^)[A-Z]/, (v) -> "-#{v}").toLowerCase()
	Range[type] = require "./range/#{modName}"

Range.matchString = (range) ->
	return unless typeof range is 'string'
	range = range.toLowerCase().trim()
	if range not of matchCache
		for type in RANGE_TYPES
			if Range[type].matchString(range)
				log.debug "Matched '#{range}' as '#{type}'"
				matchCache[range] = type
				break
	return matchCache[range]

Range.matchStrings = (ranges) -> ranges.split(/\s*,\s*/).map Range.matchString

Range.parseRange = (range) ->
	range = range.toLowerCase().trim()
	if range not of parseCache
		type = Range.matchString(range)
		throw new Error("Could not determine range type for '#{range}'") unless type
		parseCache[range] = Range[type].parse(range)
	return parseCache[range]

Range.parseRanges = (ranges) -> ranges.split(/\s*,\s*/).map Range.parseRange

Range.parseDate = (date) ->
