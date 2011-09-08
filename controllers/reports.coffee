### Reports - Business metric reporting for the salon ###

cfg = require '../config/config'    # contains API keys, etc.
 
# Initialize Models
Appointment = require '../models/appointment-model'
Product = require '../models/product-model'
Service = require '../models/service-model'
User = require '../models/user-model'

exports.Reports = class Reports

  # Daily report - sales, etc
  daily: (startDate, endDate, callback)  ->

    # HACK - doesn't read dates yet
    startDate = new Date(2011, 8, 1, 5, 6, 7)

    # We only care about start date for daily report
    startDate.setHours 0, 0, 0
    endDate = new Date(startDate)    
    endDate.setHours 23, 59, 59
    
    @report = {}   # JSON representing report output
    
    Service.find { active: 1 }, (err, services) =>
      Product.find { active: 1 }, (err, products) =>
      
        # Grab all transactions in the time period
        Appointment.find { 'transactions.date.updated': {'$gte': startDate, '$lte': endDate }, 'confirmed': true }, (err, data) =>
          # console.log data

          # Services
          @report.services = {}
          @report.services.total = 0
          
          # Products
          @report.products = {}
          @report.products.total = 0
          
          # Payments
          @report.payments = {}
          @report.payments.total = 0

          for appointment in data
            for transaction in appointment.transactions
                        
              if transaction.service.price  # We can't just check for .service because of empty JSON issues
                # Ok it's a service, now process it!
                @report.services.total += transaction.service.price
            
                # Convert service id to name
                for service in services
                  if parseInt(transaction.service.id) is parseInt(service.uid)
                    transaction.service.name = service.name
            
                if !@report.services["#{transaction.service.name}"]
                  @report.services["#{transaction.service.name}"] = []

                @report.services["#{transaction.service.name}"].push parseFloat transaction.service.price
                
            
              # Retail
              if transaction.product.price # Gotta check for .price because otherwise it returns {}
                @report.products.total += transaction.product.price
              
                # Convert product id to name
                for product in products
                  if parseInt(transaction.product.id) is parseInt(product.uid)
                    transaction.product.name = product.brand[0].name + ' ' + product.name
                
                if !@report.products["#{transaction.product.name}"]
                  @report.products["#{transaction.product.name}"] = []
                
                @report.products["#{transaction.product.name}"].push parseFloat transaction.product.price
            
            # Payment Type
            for payment in appointment.payments
              console.log payment
              if !@report.payments["#{payment.type}"]
                @report.payments["#{payment.type}"] = []
              @report.payments["#{payment.type}"].push parseFloat payment.amount
              @report.payments.total += parseFloat payment.amount
            

          
          # Tax
          @report.services.tax = Math.round(@report.services.total * cfg.SERVICE_TAX * 100) / 100 # Quickie round to 2 decimals
          @report.products.tax = Math.round(@report.products.total * cfg.PRODUCT_TAX * 100) / 100 

          # Totals
          @report.total = @report.services.total + @report.products.total
      
          callback @report
