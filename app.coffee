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
  users.get (json) ->
    res.send json

app.get '/import', (req, res) ->
  users = new Users
  imp = new Import
 
  # Takes a single user (json), cleans it up, shoves it into mongo 
  imp.users (json) =>
    for user in json.users
      
      for key, value of user

        # Strip null or empty strings
        if value is null or value is ''
          delete user[key]

      # Phone numbers -> array/json
      user.phone = []
      if user.phone_primary_type is 'pager'
        console.log 'seriously?!'
      if user.phone_primary_number
        user.phone.push {number: user.phone_primary_number, type: user.phone_primary_type}      
      delete user.phone_primary_number
      delete user.phone_primary_type

      if user.phone_secondary_number
        user.phone.push {number: user.phone_secondary_number, type: user.phone_secondary_type}      
      delete user.phone_secondary_number
      delete user.phone_secondary_type
     
      # Address -> array/json
      user.address = {}
      if user.address_street
        user.address.street = user.address_street
        delete user.address_street
      if user.address_apartment
        user.address.apartment = user.address_apartment
        delete user.address_apartment        
      if user.address_city
        user.address.city = user.address_city
        delete user.address_city        
      if user.address_state
        user.address.state = user.address_state
        delete user.address_state        
      if user.address_zip
        user.address.zip = user.address_zip
        delete user.address_zip              
      if user.address_country
        user.address.country = user.address_country
        delete user.address_country

      # Birthdays -> Remove dummy data
      if user.birthdate is '0000-00-00' or '1969-12-31'
        delete user.birthdate
      
      # Password -> array/json
      if user.password_salt
        user.password = {}
        user.password.salt = user.password_salt
        delete user.password_salt        
      if user.password_hash
        user.password.hash = user.password_hash
        delete user.password_hash
        

      users.set user, (callback) ->
  

### Socket.io Stuff ###
# Note, may need authentication later: https://github.com/dvv/socket.io/commit/ff1bcf0fb2721324a20f9d7516ff32fbe893a693#L0R111

io.enable 'browser client minification'
io.set 'log level', 2

app.listen process.env.PORT or 3000 