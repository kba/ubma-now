class PlaceCollection

	constructor : (@type, @date) ->
		@clear()

	clear : ->
		@places = []

	fetch : (cb) ->
		superagent
			.get('/api/dateTime?q=' + @date.format("YYYY-MM-DD HH:mm"))
			.end (err, res) =>
				json = JSON.parse(res.text)
				for name,def of json
					@places.push new Place(name, def)
				return cb @places
