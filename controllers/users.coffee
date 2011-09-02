cfg = require '../config/config'    # contains API keys, etc.
 
# Initialize Users Model
User = require '../models/user-model'

exports.Users = class Users

  get: (callback) ->
    # Show all users
    User.find {}, (err, data) =>
      if err
        console.log err
      else
        callback data
    
  set: (json, callback) ->
    # Add a user given some json
    # Callback should be error or no callback if successful
    user = new User json
    console.log user
    user.save (err) ->
      if err
        console.log err
    # console.log user
    
  update: (id) ->
    
  remove: (id) ->
    
  import: (user) ->
    console.log user
    # Takes a single user (json), cleans it up, shoves it into mongo
      
    # Clean up the data a bit
    
    @set user, (callback) ->
      # console.log callback