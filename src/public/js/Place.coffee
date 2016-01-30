class Place

	constructor : (@_id, def) ->
		@[k] = v for k,v of def.data
		@name or= @_id
