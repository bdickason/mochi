### Main client-side application code ###

# Dependencies:
#   -JQuery
#   -Handlebars (client-side templating)

$ ->
  ### Loaders ###
  $(".chzn-select").chosen() # Chosen - sexy dropdowns and selects! See: /lib/chosen/chosen.jquery.min.js
  
  
  class window.Routes extends Backbone.Router
    routes:
      '!/salesTax/:startDate/:endDate': 'salesTax'
      '!/newClients/:startDate/:stylist': 'newClients'
      '!/newClients/:startDate': 'newClients'      
    
    salesTax: (startDate, endDate) ->
      window.salesTax = new SalesTax
      window.salesTaxView = new SalesTaxView { collection: salesTax }
      
    newClients: (startDate, stylist) ->
      window.reportView = new ReportView { el: $('.containerOuter') } # Overall report container

      window.newClients = new NewClients { startDate, stylist }                                         # see reports.coffee
      window.selectStylist = new SelectStylist { el: $('.srchResult'), collection: newClients }       # see reports.coffee
      window.newClientsView = new NewClientsView { el: $('.listingContainer'), collection: newClients }   # see reports.coffee

      # class window.datePicker extends
  
  routes = new Routes
  Backbone.history.start()