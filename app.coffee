http = require 'http'
url = require 'url'
express = require 'express'
Redis = require 'redis'
RedisStore = (require 'connect-redis')(express)
sys = require 'sys'
cfg = require './config/config.js'    # contains API keys, etc.
winston = require 'winston'

# Setup logging
global.logger = new (winston.Logger)( {
  transports: [
    new (winston.transports.Console)({ level: 'debug', colorize: true }), # Should catch 'debug' levels (ideally error too but oh well)
    ]
})

 
# Setup Server
app = express.createServer()
io = (require 'socket.io').listen app

# Start up redis to cache stuff
redis = Redis.createClient cfg.REDIS_PORT, cfg.REDIS_HOSTNAME
redis.on 'error', (err) ->
  console.log 'REDIS Error:' + err

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.register '.html', require 'jade'
  app.use express.methodOverride()
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.session { secret: cfg.SESSION_SECRET, store: new RedisStore, key: cfg.SESSION_ID }
  app.use app.router
  app.use express.static __dirname + '/public'  

app.dynamicHelpers { session: (req, res) -> req.session }

# Initialize DB
global.db = require('./models/db').db

### Initialize controllers ###
Users = (require './controllers/users').Users
Import = (require './controllers/utils/import').Import   # Temporary importer script from mysql

# Home Page
app.get '/', (req, res) ->
  console.log 'blah'

app.get '/users', (req, res) ->
  users = new Users
  imp = new Import
  
  imp.users (json) =>
    for user in json.users
      # Takes a single user (json), cleans it up, shoves it into mongo

      # HACK - for some reason doing a 'for key in user' doesn't work so this will have to do for now
      # Clean up the data a bit
      if user.email is null or user.email is ''
        delete user.email
      if user.uid is null or user.uid is ''
        delete user.uid
      if user.last_transaction_date is null or user.last_transaction_date is ''
        delete user.last_transaction_date
      if user.password_hash is null or user.password_hash is ''
        delete user.password_hash
      if user.password_salt is null or user.password_salt is ''
        delete user.password_salt
      if user.ssn is null or user.ssn is ''
        delete user.ssn
      if user.permissions is null or user.permissions is ''
        delete user.permissions
      if user.address_apartment is null or user.address_apartment is ''
        delete user.address_apartment
      


      users.set user, (callback) ->

  
  # users.get (json) ->
  #     res.send json

  

### Socket.io Stuff ###
# Note, may need authentication later: https://github.com/dvv/socket.io/commit/ff1bcf0fb2721324a20f9d7516ff32fbe893a693#L0R111

io.enable 'browser client minification'
io.set 'log level', 2

app.listen process.env.PORT or 3000 