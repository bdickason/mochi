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
      # window.stylists = new Stylists                                          # see users.coffee
      # window.stylistSelector = new StylistSelector {collection: stylists }    # see users.coffee
      window.newClients = new NewClients { startDate, stylist }                        # see reports.coffee
      window.newClientsView = new NewClientsView { el: $('.containerOuter'), collection: newClients }   # see reports.coffee

      # class window.datePicker extends
  
  routes = new Routes
  Backbone.history.start()