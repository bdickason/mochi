### Report class ###
  # Displays and persists all reports

$ ->
  class window.Report extends Backbone.Model
  
  ### Reports - Base collection for all reports ###
  class window.Reports extends Backbone.Collection
    model: Report
  
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


  ### New Clients Report ###
  # Collection
  class window.NewClients extends Reports
    initialize: (params) ->
      if params.startDate
        @startDate = params.startDate

      @setStylist params.stylist
    
    setStylist: (stylist) ->
      if stylist
        @stylist = stylist
        @url = "/api/reports/newClients/#{@startDate}/#{@stylist}"
      else
        delete @stylist
        @url = "/api/reports/newClients/#{@startDate}"      
    
  # View
  class window.NewClientsView extends Backbone.View
      
    events: 
      'change #stylists': 'selectStylist'
  
    initialize: ->
      @el = $('.containerOuter')
      _.bindAll this, 'render'
      @collection.bind 'reset', @render
      @collection.bind 'all', @debug  # Simple debugger to tell me which events fire

      # Compile Handlebars template at init (Not sure if we have to do this each time or not)
      source = $('#newClients-template').html()
      @template = Handlebars.compile source

      # Get the latest collections
      @collection.fetch()

    render: ->
      console.log 'rendering!'
      console.log @collection.toJSON()
      # Render Handlebars template
      renderedContent = @template { report: @collection.toJSON() }
      $(@el).html renderedContent

      # Hack - make chosen dropdown re-render itself after render
      $('.chzn-select').chosen()
      return this

    selectStylist: (e) ->
      # Switch up the collection to display the new stylist that's been selected
      
      @collection.setStylist $(e.currentTarget).val() # Pass the stylist ID from the dropdown to the collection
      
      @collection.fetch() # Hack to get collection to re-render itself    
    
  
    debug: (e) ->
      # Simple debugger to tell me what event fired
      console.log "Fired event: #{e}"
  