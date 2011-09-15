### Report class ###
  # Displays and persists all reports

$ ->
  class window.Daily extends Backbone.Model
  
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
      
      # Compile Handlebars template at init (Not sure if we have to do this each time or not)
      source = $('#salesTax-template').html()
      @template = Handlebars.compile source
      
      # Get the latest collections
      @collection.fetch()
      
    render: ->
      # Render Handlebars template
      console.log 'rendering!'
      console.log @collection.toJSON()
      renderedContent = @template { report: @collection.toJSON() }
      $(@el).html renderedContent
      return this