### Main client-side application code ###

# Dependencies:
#   -JQuery
#   -Handlebars (client-side templating)

$ ->
  
  class window.Routes extends Backbone.Router
    routes:
      '!/daily/:startDate': 'daily'
    
    daily: (startDate) ->
      console.log 'worked!'
      console.log startDate # Pass this into the collection

      window.reports = new Reports
      window.reportView = new ReportView { collection: reports }

      # class window.datePicker extends
  
  routes = new Routes
  Backbone.history.start()