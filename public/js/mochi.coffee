### Main client-side application code ###

# Dependencies:
#   -JQuery
#   -Handlebars (client-side templating)

$ ->
  
  window.Daily = Backbone.Model.extend {}
  
  class window.Reports extends Backbone.Collection
    model: Daily
    url: '/api/reports/salesTax/06-01-2011/08-31-2011'
    
    
  class window.ReportView extends Backbone.View
    tagName: 'div'
    className: 'userWrapper'
      
    initialize: ->
      @el = '.userWrapper'
      _.bindAll this, 'render'
      @collection.bind 'reset', @render
      @model.view = this
      
      # Compile Handlebars template at init (Not sure if we have to do this each time or not)
      source = $('#salesTax-template').html()
      @template = Handlebars.compile source
      
      # Get the latest collections
      @collection.fetch()
      
    render: ->
      # Render Handlebars template
      console.log 'rendering!'
      renderedContent = @template @model.toJSON() #
      $(@el).html renderedContent
      return this
  
  window.report = new Daily {dates: {start: 'blah', end: 'blah2'}}
  window.reports = new Reports

  window.reportView = new ReportView {model: report, collection: reports }
