### Report class ###
  # Displays and persists all reports

$ ->
  class window.Daily extends Backbone.Model
  
  ### Reports - Base collection for all reports ###
  class window.Reports extends Backbone.Collection
    model: Daily
  
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


  ### New Clients Report ###
  # Collection
  class window.NewClients extends Reports
    url: '/api/reports/newClients/09-01-2010' # startDate/stylist (optional)
    
  # View
  class window.NewClientsView extends Backbone.View
    tagName: 'div'
    className: 'userWrapper'

    initialize: ->
      @el = '.userWrapper'
      _.bindAll this, 'render'
      @collection.bind 'reset', @render

      # Compile Handlebars template at init (Not sure if we have to do this each time or not)
      source = $('#newClients-template').html()
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
