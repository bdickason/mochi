### Report class ###
  # Displays and persists all reports

class window.Report
  constructor: (data) ->
    @data = data
    
  render: ->
    source = $('#salesTax-template').html()
    template = Handlebars.compile source
    $('.userWrapper').html template @data