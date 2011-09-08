cfg = require '../config/config'    # contains API keys, etc.
 
# Initialize Users Model
User = require '../models/user-model'

exports.Users = class Users

  # FIND - Grab a user by custom criteria
  
  
  # GET - Grab a user by UID
  get: (uid, query, callback) ->
    # Always check cache first - this should eventually go in each controller
    redisKey = "/users/#{uid}#{JSON.stringify query}"
    redis.get redisKey, (err, data) ->
      if data
        callback eval data
      else
        # Cache is clean, go grab it from mongo    
        if uid
          # Find a single user
          User.findOne { uid: uid }, (err, data) ->
            if err
              console.log err
            else
              redis.set redisKey, JSON.stringify data
              callback data
        else
          options = {}        
          if query.page
            options.limit = 20
            options.skip = options.limit * query.page
            
          # Show all users
          User.find {}, [], options, (err, data)=>
            if err
              console.log err
            else
              redis.set redisKey, JSON.stringify data
              callback data
  
  set: (json, callback) ->
    # Add a user given some json
    # Callback should be error or no callback if successful
    user = new User json

    User.findOne {uid: user.uid}, (err, data) ->
      if data.length is 0
        # Does not exist, save it!
        user.save (err) ->
          if err
            console.log err
    
  update: (id) ->
    
  remove: (id) ->