Moment = require 'moment'
module.exports =

	DATE_REGEX : /\d{4}-\d{2}-\d{2}/

	TIME_REGEX : /\d{1,2}:\d{2}/

	formatDate : (date) ->
		return Moment(date).format('YYYY-MM-DD')

	formatTime : (date) ->
		return Moment(date).format('HH:mm')

	formatDateTime : (date) ->
		return Moment(date).format('YYYY-MM-DD HH:mm')
