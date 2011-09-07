cfg = require '../config/config'    # contains API keys, etc.
 
# Initialize Products Model
Service = require '../models/service-model'

exports.Services = class Services

  get: (uid, callback) ->
    # Always check cache first - this should eventually go in each controller
    redisKey = "/services/#{uid}"
    redis.get redisKey, (err, data) ->
      if data
        callback eval data
      else
        # Cache is clean, go grab it from mongo    
        if uid
          # Find a single service
          Service.find { uid: uid }, (err, data) ->
            if err
              console.log err
            else
              redis.set redisKey, JSON.stringify data
              callback data
        else
          # Show all services
          Service.find {}, (err, data) =>
            if err
              console.log err
            else
              redis.set redisKey, JSON.stringify data
              callback data    
    
  set: (json, callback) ->
    # Add a service given some json
    # Callback should be error or no callback if successful
    service = new Service json

    Service.find { uid: service.uid }, (err, data) ->
      if data.length is 0
        # Does not exist, save it!
        service.save (err) ->
          if err
            console.log err
    
  update: (id) ->
    
  remove: (id) ->