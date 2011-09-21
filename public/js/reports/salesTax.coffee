$ -> 
  ### Sales Tax Report ###
  # Collection
  class window.SalesTax extends Reports
    initialize: ->
      console.log @startDate
      # @url = "/api/reports/salesTax/#{startDate}/#{endDate}" # startDate/endDate (optional)
      @url = "/api/reports/salesTax/06-01-2011/08-31-2011"

  # View
  class window.SalesTaxView extends Backbone.View
    tagName: 'div'
    className: 'containerOuter'

    initialize: ->
      @el = '.containerOuter'
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


