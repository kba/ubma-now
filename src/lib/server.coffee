Express = require 'express'
FindUp = require 'find-up'
Path = require 'path'
Fs = require 'fs'
CSON = require 'cson'
Cors = require 'cors'

{FormatUtils, RulesetDB} = require 'moment-rule'

log = require('easylog')(module)

PKGDIR = Path.dirname(FindUp.sync('package.json', cwd : __dirname))
DATADIR = Path.join(PKGDIR, 'data', 'cson')

DB = new RulesetDB()

Fs.readdirSync(DATADIR).map (cson) ->
	name = cson.replace('.cson', '')
	ruleset = DB.put('OpeningHours', name, CSON.load(Path.join(DATADIR, cson)))

app = Express()
app.use(Cors())

app.get '/', (req, res) -> res.render 'hello'

FormatUtils.Type.map (type) ->
	endpoint = type[0].toLowerCase() + type.substring(1)
	app.get "/api/#{endpoint}", (req, res) ->
		log.debug "#{endpoint}: Searching matching rulesets for #{req.query.q}"
		res.send DB.find type, req.query.q

app.set('views', Path.join(PKGDIR, 'templates'))
app.set('view engine', 'jade')
app.locals.pretty = true
app.set('json spaces', 2)
app.use(Express.static(Path.join(PKGDIR, 'public')))
app.listen(3000)
