### Report class ###
  # Displays and persists all reports

$ ->

  ### Simple report model ###
  class window.Report extends Backbone.Model
  
  ### Reports - Base collection for all reports ###
  class window.Reports extends Backbone.Collection
    model: Report 

  # Overall report master view!
  class window.ReportView extends Backbone.View
    initialize: ->
      @el = $('.containerOuter')
      _.bindAll this, 'render'
    
      # Compile Handlebars template at init (Not sure if we have to do this each time or not)
      source = $('#report-template').html()
      @template = Handlebars.compile source
      @render()
      
    render: ->
      console.log 'got here'
      renderedContent = @template { }
      $(@el).html renderedContent