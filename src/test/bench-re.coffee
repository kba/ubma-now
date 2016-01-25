Range  = require '../lib/range'

items = [
	'2015-01-08'
	'2015-01-01 - 2016-02-02'
	'*'
	'Mo'
	'So,Mo,Sa,Di'
	'So,Mo,Sa ,Di'
	'So-Mo'
	'08:00 - 07:00'
	'07:00  - 00:00'
]
str = [0 .. 5000].map(-> items[Math.floor(Math.random()*items.length)]).join(',')
Range.parseRanges(str)
