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
Reports = (require './controllers/reports').Reports
Import = (require './controllers/utils/import').Import   # Temporary importer script from mysql

# Home Page
app.get '/', (req, res) ->
  # Index - serve up backbone and all that single-page sexiness
  res.render 'index'

app.get '/favicon.ico', (req, res) ->

app.get '/import', (req, res) ->
  doImport req, res

app.get '/api/reports/:report/:startDate?/:endDate?', (req, res) ->
  report = new Reports

  switch req.params.report
    when 'daily'
      report.daily req.params.startDate, req.params.endDate, (json) ->
        res.send json
    
  
# Get One - Generic Route
app.get '/api/:route/:uid?', (req, res) ->
  obj = getRoute req.params.route

  obj.get req.params.uid, req.query, (json) ->
    res.send json
        
### Socket.io Stuff ###
# Note, may need authentication later: https://github.com/dvv/socket.io/commit/ff1bcf0fb2721324a20f9d7516ff32fbe893a693#L0R111

io.enable 'browser client minification'
io.set 'log level', 2

app.listen process.env.PORT or 3000 

### Utility Functions ###

getRoute = (route) ->
  switch route
    when 'appointments'
      obj = new Appointments
    when 'products'
      obj = new Products
    when 'services'
      obj = new Services
    when 'users'
      obj = new Users
    when 'reports'
      obj = new Reports

  return obj
  
doImport = (req, res) ->
  # We should probably rip this out into a import.js standalone file that gets invoked nightly via cron or somethin.
  
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


  appointments = new Appointments
  impAppointments = new Import
  impTransactions = new Import  
  impTransactionEntries = new Import

  impTransactions.transactions (transactionjson) =>
    impTransactionEntries.transactionEntries (entriesjson) =>
        # woohoo nested callback city!        
        ### Transactions in phpcode = Appointments in nodecode 
            -Appointments in php = Transactions in node
            -Transaction_entries in php = Transactions in node  (sometimes tied together) ###
        for appointment in transactionjson.transactions
          appointment.uid = parseInt appointment.transaction_id
          delete appointment.transaction_id

          appointment.total = parseFloat appointment.transaction_total
          delete appointment.transaction_total
          
          if parseInt appointment.transaction_void isnt 0
            appointment.void = {}
            appointment.void.void = true
            if appointment.transaction_void_by_uid
              appointment.void.user = parseInt appointment.transaction_void_by_uid
            if appointment.transaction_void_date
              appointment.void.date = appointmnet.transaction_void_date
          
          appointment.confirmed = Boolean parseInt appointment.transaction_finalized
          delete appointment.transaction_finalized
          
          appointment.payments = []
          # Currently, only supports 1 payment at a time, so we can push and reference payments[0]
          if appointment.transaction_payment_type isnt null or appointment.transaction_payment_type isnt ''
            appointment.payments.push { type: appointment.transaction_payment_type, amount: appointment.total}

          # Handle individual transactions
          appointment.transactions = []
          
          for entry in entriesjson.entries
            if appointment.uid is parseInt entry.transaction_id
              entry.uid = parseInt entry.transaction_entry_id
              delete entry.transaction_entry_id
              
              entry.client = parseInt appointment.transaction_uid  # In the php client, every transaction has only one user

              entry.stylist = parseInt entry.transaction_entry_uid  # uid in this case is a stylist user ID
              delete entry.transaction_entry_uid
              
              # Services and Products
              switch entry.transaction_entry_type
                when 'service'
                  entry.service = {}
                  entry.service.id = entry.transaction_entry_service_id
                  entry.service.price = parseFloat entry.transaction_entry_price_added
                when 'product'              
                  entry.product = {}
                  entry.product.id = entry.transaction_entry_service_id   # Original software reused this variable
                  entry.product.quantity = entry.transaction_entry_quantity
                  entry.product.price = parseFloat entry.transaction_entry_price_added

              delete entry.transaction_entry_quantity
              delete entry.transaction_entry_price_added
              delete entry.transaction_entry_service_id
              delete entry.transaction_entry_type
              
              # Date -> JSON object
              entry.date = {}
              entry.date.updated = entry.transaction_entry_date_added
              delete entry.transaction_entry_date_added
              
              # Don't need this crap
              delete entry.transaction_id
            
              appointment.transactions.push entry

          # Delete the crap we don't need
          delete appointment.transaction_code   # can't figure out what this is
          delete appointment.transaction_paid   # doesn't seem to be set anywhere
          delete appointment.transaction_payment_type
          delete appointment.transaction_author_uid
          delete appointment.transaction_updated_uid
          delete appointment.transaction_stylists
          delete appointment.transaction_products
          delete appointment.transaction_client_name
          delete appointment.transaction_void_date
          delete appointment.transaction_void_by_uid
          delete appointment.transaction_void

          # Don't think we need this stuff
          delete appointment.transaction_uid
          delete appointment.transaction_created_date
          delete appointment.transactoin_updated_date

          appointments.set appointment, (callback) ->
          
        res.send 'Done!'