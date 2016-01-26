Moment = require 'moment'

WEEKDAY_MAP = {}
for locale in ['en', 'de']
	for format in ['weekdays', 'weekdaysMin', 'weekdaysShort']
		localeData = Moment.localeData(locale)
		for weekday in [0 .. 6]
			str = localeData[format].apply(localeData, [Moment(weekday, 'e')])
			WEEKDAY_MAP[str.toLowerCase().replace(/[^a-z]/g, '')] = weekday

DEFAULT_NAMED_DAYS = 'holidays-de-bw'
NAMED_DAYS = {
	"#{DEFAULT_NAMED_DAYS}" :
		'Heiligabend' : '2000-12-24 yearly'
		'1. Weihnachtsfeiertag' : '2000-12-25 yearly'
		'2. Weihnachtsfeiertag' : '2000-12-26 yearly'
		'Silvester' : '2000-12-31 yearly'
		'Neujahr' : '2000-01-01 yearly'
		'Tag der Arbeit' : '2000-05-01 yearly'
}

module.exports = {
	WEEKDAY_MAP
	NAMED_DAYS
	DEFAULT_NAMED_DAYS
}
