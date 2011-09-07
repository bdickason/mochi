cfg = require '../config/config'    # contains API keys, etc.
 
# Initialize Users Model
User = require '../models/user-model'

exports.Users = class Users

  get: (uid, callback) ->
    # Always check cache first - this should eventually go in each controller
    redisKey = "/users/#{uid}"
    redis.get redisKey, (err, data) ->
      if data
        callback eval data
      else
        # Cache is clean, go grab it from mongo    
        if uid
          # Find a single user
          User.find { uid: uid }, (err, data) ->
            if err
              console.log err
            else
              redis.set redisKey, JSON.stringify data
              callback data
        else
          # Show all users
          User.find {}, (err, data) =>
            if err
              console.log err
            else
              redis.set redisKey, JSON.stringify data
              callback data
  
  set: (json, callback) ->
    # Add a user given some json
    # Callback should be error or no callback if successful
    user = new User json

    User.find {uid: user.uid}, (err, data) ->
      if data.length is 0
        # Does not exist, save it!
        user.save (err) ->
          if err
            console.log err
    
  update: (id) ->
    
  remove: (id) ->