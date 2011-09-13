### Main client-side application code ###

# Dependencies:
#   -JQuery
#   -Handlebars (client-side templating)

$ ->
  window.Daily = Backbone.Model.extend {}
    
  window.ReportView = Backbone.View.extend
    tagName: 'div'
    className: 'userWrapper'
      
    initialize: ->
      # @el = '.userWrapper'
      # Compile Handlebars template at init (Not sure if we have to do this each time or not)
      source = $('#salesTax-template').html()
      @template = Handlebars.compile source
      
    render: ->
      # Render Handlebars template
      renderedContent = @template @model.toJSON() #
      $(@el).html renderedContent
      return this
      
  window.report = new Daily {dates: {start: 'blah', end: 'blah2'}}
  
  window.reportView = new ReportView {model: report}