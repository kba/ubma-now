class Place

	constructor : (@name, def) ->
		@[k] = v for k,v of def.data
