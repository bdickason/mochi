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
      window.report = new Daily {}
      window.reports = new Reports

      window.reportView = new ReportView { collection: reports }

      # class window.datePicker extends
  
  routes = new Routes
  Backbone.history.start()