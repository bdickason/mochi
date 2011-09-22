### Main client-side application code ###

# Dependencies:
#   -JQuery
#   -Handlebars (client-side templating)

$ ->
  class window.Routes extends Backbone.Router
    routes:
      
      # Reports
      '!/reports/salesTax/:startDate/:endDate': 'salesTax'
      '!/reports/newClients/:startDate/:stylist': 'newClients'
      '!/reports/newClients/:startDate': 'newClients'      
      
      # Users
      '!/users/:id': 'user'
      
    ### Reports ###
    
    salesTax: (startDate, endDate) ->
      window.salesTax = new SalesTax
      window.salesTaxView = new SalesTaxView { collection: salesTax }
      
    newClients: (startDate, stylist) ->
      window.reportView = new ReportView { el: $('.containerOuter') } # Overall report container

      window.newClients = new NewClients { startDate, stylist }                                         # see reports.coffee
      window.selectStylist = new SelectStylist { el: $('.srchResult'), collection: newClients }       # see reports.coffee
      # window.datePicker = new DatePicker { el: $('.datePicker')}
      window.newClientsView = new NewClientsView { el: $('.listingContainer'), collection: newClients }   # see reports.coffee

      # class window.datePicker extends
  

    ### Users ###
    user: (id) ->
      window.users = new Users { id }
      window.usersView = new UsersView { el: $('.userWrapper'), collection: users }
    
  routes = new Routes
  Backbone.history.start()