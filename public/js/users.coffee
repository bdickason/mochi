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
  class window.Stylists extends Users

  ### Clients ###
  class window.Clients extends Users
  