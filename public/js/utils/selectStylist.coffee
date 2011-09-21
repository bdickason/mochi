$ ->
  ### Utility - Stylist Dropdown ###
  # Pick a stylist from a dropdown
  class window.SelectStylist extends Backbone.View
    events: 
      'change #stylists': 'selectStylist'

    initialize: ->
      @el = $('.srchResult')
      _.bindAll this, 'render'
      @collection.bind 'reset', @render
      # @collection.bind 'all', @debug  # Simple debugger to tell me which events fire
      # Compile Handlebars template at init (Not sure if we have to do this each time or not)
      source = $('#selectStylist-template').html()
      @template = Handlebars.compile source
  
    render: ->
      # Hack - make chosen dropdown re-render itself after render
      renderedContent = @template { report: @collection.toJSON() }
      $(@el).html renderedContent  

      $('.chzn-select').chosen()
    
      @collection.unbind 'reset', @render  # Hack so we don't re-render the dropdown every time
    
    selectStylist: (e) ->
      # Switch up the collection to display the new stylist that's been selected

      @collection.setStylist $(e.currentTarget).val() # Pass the stylist ID from the dropdown to the collection

      @collection.fetch() # Hack to get collection to re-render itself