### Main client-side application code ###

# Dependencies:
#   -JQuery
#   -Handlebars (client-side templating)

$ ->
  
  window.report = new Daily {dates: {start: 'blah', end: 'blah2'}}
  window.reports = new Reports

  window.reportView = new ReportView { collection: reports }

  # class window.datePicker extends