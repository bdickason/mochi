### Main client-side application code ###

# Dependencies:
#   -JQuery
#   -Handlebars (client-side templating)

$ ->
  
  class window.Routes extends Backbone.Router
    routes:
      '!/salesTax/:startDate/:endDate': 'salesTax'
      '!/newClients/:startDate': 'newClients'
      '!/newClients/:startDate/:stylist': 'newClients'
    
    salesTax: (startDate, endDate) ->
      console.log 'worked!'
      console.log startDate # TODO: Pass this into the collection

      window.salesTax = new SalesTax
      window.salesTaxView = new SalesTaxView { collection: salesTax }
      
    newClients: (startDate, stylist) ->
      console.log 'worked!'
      console.log startDate
      
      window.newClients = new NewClients 
      window.newClientsView = new NewClientsView { collection: newClients }

      # class window.datePicker extends
  
  routes = new Routes
  Backbone.history.start()