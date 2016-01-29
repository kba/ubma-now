Moment = require 'moment'

Format =
	Date : 'YYYY-MM-DD'
	Time : 'HH:mm'
	DateTime : 'YYYY-MM-DD HH:mm'

Regex =
	Time : /\d{1,2}:\d{2}/
	Date : /\d{4}-\d{2}-\d{2}/
	DateTime : /\d{4}-\d{2}-\d{2}\x20\d{1,2}:\d{2}/

module.exports = FormatUtils = { Regex, Format }

FormatUtils.Type = Object.keys(Format)

FormatUtils.Type.map (type) ->
	FormatUtils["format#{type}"] = (date) ->
		return Moment(date).format(Format[type])
	FormatUtils["parse#{type}"] = (date) ->
		if date instanceof Moment
			return date
		if typeof date is 'string'
			moment = Moment(date, Format[type])
			if (not moment.isValid())
				throw new Error("Cannot parse as #{type}: #{date}")
			return moment
