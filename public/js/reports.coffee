### Report class ###
  # Displays and persists all reports

$ ->
  ### Master view for the Report class ###
  class ReportView extends Backbone.View
    initialize: (params) ->
      # Creates the different objects used in each view
      switch params.type
        when 'newClients'
          # Stylist Selector
          # Date Picker (Start? or Start + End)
          # newClientsView - table below
          console.log 'new clients'
        when 'daily'
          # Date Picker (Start)
          # dailyView - table below
          console.log 'daily'

  ### Simple report model ###
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
      if stylist and stylist isnt 'null'  # Need second piece since we get a string back from the <select>
        @stylist = stylist
        @url = "/api/reports/newClients/#{@startDate}/#{@stylist}"
      else
        delete @stylist
        @url = "/api/reports/newClients/#{@startDate}"
    
  ### New Client report View ###
  class window.NewClientsView extends Backbone.View  
    initialize: ->
      @el = $('.listingContainer')
      _.bindAll this, 'render'
      @collection.bind 'reset', @render
      @collection.bind 'all', @debug  # Simple debugger to tell me which events fire

      # Compile Handlebars template at init (Not sure if we have to do this each time or not)
      source = $('#newClients-template').html()
      @template = Handlebars.compile source

      # Get the latest collections
      @collection.fetch()

    render: ->
      console.log @collection.toJSON()
      # Render Handlebars template
      renderedContent = @template { report: @collection.toJSON() }
      $(@el).html renderedContent

      return this
  
    debug: (e) ->
      # Simple debugger to tell me what event fired
      console.log "Fired event: #{e}"

  # Pick a stylist from a dropdown
  class window.SelectStylist extends Backbone.View
    events: 
      'change #stylists': 'selectStylist'

    initialize: ->
      @el = $('.srchResult')
      _.bindAll this, 'render'
      @collection.bind 'reset', @render
      @collection.bind 'all', @debug  # Simple debugger to tell me which events fire
      # Compile Handlebars template at init (Not sure if we have to do this each time or not)
      source = $('#selectStylist-template').html()
      @template = Handlebars.compile source
    
    render: ->
      # Hack - make chosen dropdown re-render itself after render
      console.log @collection
      renderedContent = @template { report: @collection.toJSON() }
      $(@el).html renderedContent
      $('.chzn-select').chosen()
      
    selectStylist: (e) ->
      # Switch up the collection to display the new stylist that's been selected

      @collection.setStylist $(e.currentTarget).val() # Pass the stylist ID from the dropdown to the collection

      @collection.fetch() # Hack to get collection to re-render itself    

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