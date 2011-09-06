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
global.redis = Redis.createClient cfg.REDIS_PORT, cfg.REDIS_HOSTNAME
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
Products = (require './controllers/products').Products
Services = (require './controllers/services').Services
Appointments = (require './controllers/appointments').Appointments
Import = (require './controllers/utils/import').Import   # Temporary importer script from mysql

# Home Page
app.get '/', (req, res) ->
  console.log 'home'

app.get '/users', (req, res) ->
  users = new Users
  users.get null, (json) ->
    res.send json
    
app.get '/users/:uid', (req, res) ->
  users = new Users
  users.get req.params.uid, (json) ->
    res.send json

app.get '/products', (req, res) ->
  products = new Products
  products.get (json) ->
    res.send json

app.get '/services', (req, res) ->
  services = new Services
  services.get (json) ->
    res.send json

app.get '/import', (req, res) ->

  ###
  users = new Users
  imp = new Import
 
  # Takes a single user (json), cleans it up, shoves it into mongo 
  imp.users (json) =>
    imp2 = new Import 
    imp.userOptions (optionsjson) =>   
  
      for user in json.users      
        for key, value of user

          # Strip null or empty strings
          if value is null or value is ''
            delete user[key]

          # Some numbers are coming back as a string not an int
          if key is 'uid' or key is 'active'
            user[key] = parseInt value

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
      
        # Notes -> array/json
        if user.notes
          tmp_notes = user.notes
          delete user.notes
          user.notes = []
          user.notes.push { message: tmp_notes }
  
        # Iterate through options and setup the user's stylists
        for entry in optionsjson.users
          if entry.uid is user.uid and entry.user_option_value isnt 'none'  # Ignore blank entries
            if !user.stylist
              user.stylist = {} # Define stylist json if it's not already defined
            if entry.user_option_tag is 'salon_stylist_cut'
              # set cut stylist
              user.stylist.cut = parseInt entry.user_option_value     # Gotta convert String to Int
            else if entry.user_option_tag is 'salon_stylist_color'
              # set color stylist
              user.stylist.color = parseInt entry.user_option_value   # Gotta convert String to Int

        # Old/deprecated stuff
        delete user.tax_info
      
        user.active = 1 # Active is not set currently
        
        if user.name  # tons of clients don't have a damn name.
          users.set user, (callback) =>
  
  # Takes a single product (json), cleans it up, shoves it into mongo 
  products = new Products
  impProducts = new Import
  impProducts.products (json) =>
    for product in json.products
      
      # Brand Names
      # Handle different brands - There's probably a better way to do this, but it'll work for now.
      brand_array = product.product_name.split ' '
      brand_first = brand_array[0].toString()
      
      switch brand_first
        when 'Simply', 'Moroccan', 'Kevin'
          # some have multiple words in their name
          product.brand = {}
          product.brand.name = (product.product_name.split ' ', 2).join(' ').toString()  # split 'em then join 'em then string 'em
          product.name = brand_array[2...].join(' ').toString()
        when 'Pretty'
          # some have no brand at all  
          product.name = product.product_name
        else
          # none of these need special handling
          product.brand = {}
          product.brand.name = brand_first
          product.name = brand_array[1...].join(' ').toString() # Pop the rest of the name back in
      delete product.product_name
      
      # Active -> Number
      product.active = parseInt product.product_active
      delete product.product_active
      
      # Product ID -> uid
      product.uid = parseInt product.product_id
      delete product.product_id
      
      # Price -> Number
      product.price = {}
      product.price.retail = parseFloat product.product_price
      delete product.product_price
      
      # Date -> rename!
      product.date_updated = product.last_updated
      delete product.last_updated
      
      # Filter out the unwanted crap
      delete product.product_sku        
      
      products.set product, (callback) ->

  services = new Services
  impServices = new Import
  impServices.services (json) =>
    for service in json.services
      for key, value of service
        # Strip null or empty strings
        if value is null or value is ''
          delete service[key]

      service.name = service.service_name
      delete service.service_name

      # Active -> Number
      service.active = parseInt service.service_active
      delete service.service_active
      
      # uid -> Number
      service.uid = parseInt service.service_id
      delete service.service_id
      
      # sku's are obsolete for services
      delete service.service_sku
      
      services.set service, (callback) ->

  ###  
  appointments = new Appointments
  impAppointments = new Import
  impTransactions = new Import  
  impTransactionEntries = new Import

  impAppointments.appointments (appointmentjson) =>
    impTransactions.transactions (transactionjson) =>
      impTransactionEntries.transactionEntries (entriesjson) =>
        # woohoo nested callback city!
        for appointment in appointmentjson.appointments
          console.log appointment
        for transaction in transactionjson
          console.log transaction
        for transentry in entriesjson
          console.log transentry
          
        # Work some magic here to figure out which transaction is which
        # and massage this into some damn fine json!
  

### Socket.io Stuff ###
# Note, may need authentication later: https://github.com/dvv/socket.io/commit/ff1bcf0fb2721324a20f9d7516ff32fbe893a693#L0R111

io.enable 'browser client minification'
io.set 'log level', 2

app.listen process.env.PORT or 3000 