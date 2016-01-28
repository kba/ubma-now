Express = require 'express'
FindUp = require 'find-up'
Path = require 'path'
Range  = require './range'
FormatUtils = require './utils'
Fs = require 'fs'
CSON = require 'cson'
RuleSet  = require './ruleset'

PKGDIR = Path.dirname(FindUp('package.json', cwd: __dirname))
DATADIR = Path.join(PKGDIR, 'data', 'cson')
DB = {}
console.log PKGDIR
Fs.readdirSync(DATADIR).map (cson) ->
	name = cson.replace('.cson', '')
	cson = CSON.load(Path.join(DATADIR, cson))
	DB[name] = RuleSet.fromRuleTree(name, cson)


app = Express()

app.get '/', (req, res) -> res.render 'hello'
app.get '/dateTime', (req, res) ->
	ret = {}
	Object.keys(DB).map (name) ->
		moment = Range.parseDate(req.query.q)
		data = DB[name].applyDateTime moment
		if data
			ret[name] = data
	res.send ret

app.set('views', Path.join(PKGDIR, 'templates'))
app.set('view engine', 'jade')
app.use(Express.static(Path.join(PKGDIR, 'public')))
app.listen(3000)
