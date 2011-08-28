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
    
  set: (id) ->
    
  update: (id) ->
    
  remove: (id) ->