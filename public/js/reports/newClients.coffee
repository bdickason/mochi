$ -> 
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
      # Render Handlebars template
      renderedContent = @template { report: @collection.toJSON() }
      $(@el).html renderedContent

      return this

    debug: (e) ->
      # Simple debugger to tell me what event fired
      console.log "Fired event: #{e}"