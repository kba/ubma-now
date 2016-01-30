class PlaceView

	constructor : (@model) ->

	render : ->
		ret = $("""
			<div>
				<h1>#{@model.name}</h1>
				<pre>#{JSON.stringify(@model)}</pre>
			</div>
		""")
		ret.addClass(if @model.open then 'open' else 'closed')
		return ret
