class PlaceView

	constructor : (@model) ->
		@model._template or= 'bb'

	render : ->
		inner = if @model._template is 'bb' then """
			<div class="panel-heading" role="tab" id="heading-#{@model._id}">
				<h4 class="panel-title">
				<a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse-#{@model._id}" aria-expanded="true" aria-controls="collaps-#{@model._id}">
					#{@model.name}
				</a>
				<a href="http://aleph.bib.uni-mannheim.de/cgi-bin/dreidplan/drei_d_plan.pl?action=index&lang=de&signatur=blank&area=#{@model._id_3d}">
					<img src="https://www.bib.uni-mannheim.de/fileadmin/images/3D-24x18.png"/>
				</a>
				</h4>
			</div>
			<div id="collapse-#{@model._id}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-#{@model._id}">
				<div class="panel-body">
					<pre>#{JSON.stringify(@model)}</pre>
					<!--
					<iframe width="66" height="66" frameborder="0" scrolling="no"
						src="https://www.bib.uni-mannheim.de/bereichsauslastung/index.php?bereich=#{@model._id_ampel}">
					</iframe>
					-->
				</div>
			</div>
		""" else if @model._template is 'mensa' then """
			<h2>
				<a href=#{@model['@id']}">#{@model.name}</a>
			</h2>
			<pre>#{JSON.stringify(@model)}</pre>
		"""
		ret = $("""
		<div class="panel panel-default #{if @model.open then 'panel-success' else 'panel-danger'}">
			#{inner}
		</div>
		""")
		return ret
