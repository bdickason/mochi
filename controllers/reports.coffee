### Reports - Business metric reporting for the salon ###

cfg = require '../config/config'    # contains API keys, etc.
 
# Initialize Models
Appointment = require '../models/appointment-model'
Product = require '../models/product-model'
Service = require '../models/service-model'
User = require '../models/user-model'

exports.Reports = class Reports

  ### Daily report - sales, etc ###
  daily: (startDate, endDate, callback)  ->

    startDate = new Date startDate

    # We only care about start date for daily report
    startDate.setHours 0, 0, 0

    # We only care about start date for daily report. End date should be the same as the start, just 24hrs later.
    endDate = new Date(startDate)    
    endDate.setHours 23, 59, 59
    
    @report = {}   # JSON representing report output
    
    @report.dates = {}  # Add dates to output
    @report.dates.start = startDate
    @report.dates.end = endDate
    
    Service.find { active: 1 }, (err, services) =>
      Product.find { active: 1 }, (err, products) =>
      
        # Grab all transactions in the time period
        Appointment.find { 'transactions.date.start': {'$gte': startDate, '$lte': endDate }, 'confirmed': true }, (err, data) =>

          # Totals
          @report.totals = {}
          
          # Services
          @report.services = []
          @report.totals.services = 0
          
          # Products
          @report.products = []
          @report.totals.products = 0
          
          # Payments
          @report.payments = []
          @report.totals.payments = 0

          for appointment in data
            for transaction in appointment.transactions
                        
              if transaction.service.price  # We can't just check for .service because of empty JSON issues
                # Ok it's a service, now process it!
                @report.totals.services += transaction.service.price
            
                # Convert service id to name
                for _service in services
                  if parseInt(transaction.service.id) is parseInt(_service.uid)
                    transaction.service.name = _service.name

                found = false
                for service in @report.services
                  if parseInt(service.uid) is parseInt(transaction.service.id)
                    service.transactions.push transaction.service.price
                    found = true
                
                if !found
                  # Doesn't exist, we need to create the array
                  newService = {}
                  newService.uid = transaction.service.id
                  newService.name = transaction.service.name
                  newService.transactions = []
                  
                  newService.transactions.push transaction.service.price
                  
                  @report.services.push newService
                
                                
              # Retail
              if transaction.product.price # Gotta check for .price because otherwise it returns {}
                @report.totals.products += transaction.product.price
              
                # Convert product id to name
                for _product in products
                  if parseInt(transaction.product.id) is parseInt(_product.uid)
                    transaction.product.name = _product.brand[0].name + ' ' + _product.name

                found = false
                for product in @report.products
                  if parseInt(product.uid) is parseInt(transaction.product.id)
                    product.transactions.push transaction.product.price
                    found = true
                
                if !found
                  # Doesn't exist, we need to create the array
                  newProduct = {}
                  newProduct.uid = transaction.product.id
                  newProduct.name = transaction.product.name
                  newProduct.transactions = []
                  
                  newProduct.transactions.push transaction.product.price
                  
                  @report.products.push newProduct

            # Payment Type
            for payment in appointment.payments
              @report.totals.payments += parseFloat payment.amount
              
              found = false
              for pay in @report.payments
                if payment.type is pay.name
                  pay.amounts.push payment.amount
                  found = true
              
              if !found
                # Doesn't exist, we need to create the array
                newPayment = {}
                newPayment.uid = payment.uid
                newPayment.name = payment.type
                newPayment.amounts = []
                
                newPayment.amounts.push payment.amount
                
                @report.payments.push newPayment
          
          # Tax
          @report.tax = {}
          @report.tax.services = Math.round(@report.totals.services * cfg.SERVICE_TAX * 100) / 100 # Quickie round to 2 decimals
          @report.tax.products = Math.round(@report.totals.products * cfg.PRODUCT_TAX * 100) / 100 

          # Totals
          @report.totals.grand = @report.totals.services + @report.totals.products
      
          callback @report

  ### Sales Tax - Quarterly Report ###
  salesTax: (startDate, endDate, callback)  ->

    startDate = new Date(startDate)
    
    # Sales tax comes in quarters:
    #   Q1: Apr 1 - May 31
    #   Q2: Jun 1 - Aug 31
    #   Q3: Aug 1 - Nov 30
    #   Q4: Dec 1 - Feb 28
    
    startDate.setHours 0, 0, 0


    endDate = new Date(endDate)   # Override the end date for this report because we're determining the range
    endDate.setHours 23, 59, 59

    @report = {}   # JSON representing report output

    # Dates
    @report.dates = {}  # Add dates to output so you can verify that the request was successful
    @report.dates.start = startDate
    @report.dates.end = endDate

    # Totals
    @report.totals = {}
    
    # Services
    @report.totals.services = 0
    @report.totals.serviceTax
    
    # Products
    @report.totals.products = 0

    # Grab all transactions in the time period
    Appointment.find { 'transactions.date.start': {'$gte': startDate, '$lte': endDate }, 'confirmed': true }, (err, data) =>      
      for appointment in data
        for transaction in appointment.transactions
          # Services
          if transaction.service.price  # We can't just check for .service because of empty JSON issues
             # Ok it's a service, now process it!
             @report.totals.services += transaction.service.price

          # Retail
          if transaction.product.price # Gotta check for .price because otherwise it returns {}
            @report.totals.products += transaction.product.price 
                 
      # Normalize totals
      @report.totals.services = Math.round(@report.totals.services * 100) / 100
      @report.totals.products = Math.round(@report.totals.products * 100) / 100
        
      # Tax
      @report.tax = {}
      @report.tax.services = Math.round(@report.totals.services * cfg.SERVICE_TAX * 100) / 100 # Quickie round to 2 decimals
      @report.tax.products = Math.round(@report.totals.products * cfg.PRODUCT_TAX * 100) / 100 

      callback @report
  
  ### New Clients Report ###
  newClients: (startDate, stylist, callback) ->
    # Displays all clients for a given stylist (or all stylists) from start date to now
    
      startDate = new Date(startDate)
      startDate.setHours 0, 0, 0  # We always want to start at the beginning of the day

      # We only care about start date for daily report, end date should be today
      endDate = new Date()
      endDate.setHours 23, 59, 59

      @report = {}   # JSON representing report output

      @report.dates = {}  # Add dates to output
      @report.dates.start = startDate
      @report.dates.end = endDate
      
      @report.clients = []
      
      # Todo - Do this more sexy and programatically instead of two separate blocks
      if stylist
        User.find { 'date_added': {'$gte': startDate, '$lte': endDate }, 'active': 1, 'stylist.id': parseInt(stylist) }, { 'phone': 1, 'name': 1, 'email': 1 }, (err, clientdata) =>
          for user in clientdata
            final = []
            if user.email
              final[0] = user.email
            if user.name
              final[1] = user.name
      
            @report.clients.push final

          ## User.find { 'type': 'stylist', 'active': 1 }, { 'name': 1, 'uid': 1 }, (err, stylistdata) =>
          ##   @report.stylists = stylistdata
          str = ''
          array = @report.clients
          for i in [0...array.length]
            line = ''
            for index in array[i]
              if line != ''
                line += ','

              line += index

            str += line + '\n'
          console.log str
          callback @report
      else
        # No stylist specified, Grab all clients added in the time period
        User.find { 'date_added': {'$gte': startDate, '$lte': endDate }, 'active': 1 }, { 'uid': 1, 'phone': 1, 'name': 1, 'email': 1, 'phone': 1, 'address': 1, 'stylist': 1 }, (err, clientdata) =>
          @report.clients = clientdata
          @report.count = clientdata.length          
          User.find { 'type': 'stylist', 'active': 1 }, { 'name': 1, 'uid': 1 }, (err, stylistdata) =>
            @report.stylists = stylistdata
            callback @report
  
  ### TMP New Clients Report - Uses transactions not users ###  
  tmpClients: (startDate, stylist, callback) ->
    # Temporary report to query transactions + return clients based on which stylist has had a transaction with that user
    
    startDate = new Date(startDate)
    startDate.setHours 0, 0, 0  # We always want to start at the beginning of the day

    # We only care about start date for daily report, end date should be today
    endDate = new Date()
    endDate.setHours 23, 59, 59

    @report = {}   # JSON representing report output

    @report.dates = {}  # Add dates to output
    @report.dates.start = startDate
    @report.dates.end = endDate
    
    @report.clients = []
    @report.count = 0
    
    query = { $or: [] } # We'll use this to catalog all the user ID's we wanna grab info for
    
    if stylist
      Appointment.find { 'transactions.stylist': parseInt(stylist) }, { 'transactions.client': 1, 'transactions.stylist': 1 }, (err, appointmentdata) =>
        for appointment in appointmentdata
          for transaction in appointment.transactions
            query['$or'].push {uid: transaction.client }  # Throw all the clients that match into our query
        
        User.find { query }, { 'phone': 1, 'name': 1, 'email': 1}, (err, userdata) =>
          for user in userdata
            final = {}
            if user.email
              final.email = user.email
            if user.name
              final.name = user.name
        
            if user.phone.length > 0                
              final.phone = []
              for phone in user.phone
                final.phone.push phone.number

            @report.count++
            @report.clients.push final
        
          callback @report

        # console.log @report ###
