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

    user.save (err) ->
      if err
        console.log user
        console.log err
    
  update: (id) ->
    
  remove: (id) ->