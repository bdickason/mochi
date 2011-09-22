### Users class ###
  # A user can be a client, a stylist, an admin, etc...

$ ->
  class window.User extends Backbone.Model
  
  ### users - Base collection ###  
  class window.Users extends Backbone.Collection
    model: User

    initialize: (params) ->
      if params.id
        @id = params.id
        @url = "/api/users/#{@id}"
        
    
    isAdmin: (id) ->
      if @model.get('type') is 'administrator'  # TODO: Make a new field for admins like 'admin': true
        return true
      else return false
        
  class window.UsersView extends Backbone.View
    initialize: ->
      @el = $('.containerOuter')
      _.bindAll this, 'render'
      @collection.bind 'reset', @render
      @collection.bind 'all', @debug  # Simple debugger to tell me which events fire

      # Compile Handlebars template at init (Not sure if we have to do this each time or not)
      source = $('#users-template').html()
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