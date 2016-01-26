module.exports = class CatchallRange
	containsDate : -> true
	containsTime : -> true
	containsDateTime : -> true
	@matchString : (str) -> str == '*'
	@parse : -> new CatchallRange()
	toString : -> '*'
