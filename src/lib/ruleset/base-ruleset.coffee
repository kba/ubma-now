FormatUtils = require '../utils'
DeepMerge = require 'deep-extend'

log = require('easylog')(module)

module.exports = class BaseRuleset

	constructor : (@name, @rules, @orig, @options) ->
		FormatUtils.Type.forEach (type) =>
			@["apply#{type}"] = (date) =>
				date = FormatUtils["parse#{type}"].apply(FormatUtils, [date])
				ret = {
					matchedRules : []
					data : {}
					# orig : @orig
				}
				dataList = @rules.map (rule) ->
					if rule["contains#{type}"].apply(rule, [date])
						# log.silly "MATCHED #{@name}[ #{rule.toString()} ]"
						ret.matchedRules.push rule.toString()
						ret.data = DeepMerge(ret.data, rule.data)
				return ret
