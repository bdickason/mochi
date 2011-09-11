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
    startDate = new Date startDate

    # We only care about start date for daily report
    startDate.setHours 0, 0, 0
    endDate = new Date(startDate)    
    endDate.setHours 23, 59, 59
    
    @report = {}   # JSON representing report output
    
    Service.find { active: 1 }, (err, services) =>
      Product.find { active: 1 }, (err, products) =>
      
        # Grab all transactions in the time period
        Appointment.find { 'transactions.date.updated': {'$gte': startDate, '$lte': endDate }, 'confirmed': true }, (err, data) =>

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
