module.exports = class CatchallRange
	contains: -> true
	@matchString: (str) -> str == '*'
	@parse : -> new CatchallRange()

