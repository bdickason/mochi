### Users class ###
  # A user can be a client, a stylist, an admin, etc...

$ ->
  class window.User extends Backbone.Model
  
  ### users - Base collection ###  
  class window.Users extends Backbone.Collection
    model: User
    url: '/api/users'
    
    isAdmin: (uid) ->
      if @model.get('type') is 'administrator'  # TODO: Make a new field for admins like 'admin': true
        return true
      else return false
        
  ### Stylists  ###
  # Stylist Base Model
  class window.Stylist extends User
  
  # Stylists Base Collection
  class window.Stylists extends Users
    initialize: (params) ->
      @url = "/api/stylists/#{params.stylist}" # /stylist id(optional)


  ###
  # Select Stylist dropdown
  # Grabs a list of stylists (Stylists) and lets the user select one to update a form
  # Made sexier with Chosen
  class window.StylistSelector extends Backbone.View
    tagName: 'div'
    className: 'srchResult'

    initialize: ->
     @el = '.srchResult' 
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
  ###
  

  ### Clients ###
  class window.Clients extends Users
  