cfg = require '../config/config'    # contains API keys, etc.
 
# Initialize Products Model
Service = require '../models/service-model'

exports.Services = class Services

  get: (uid, query, callback) ->
    # Always check cache first - this should eventually go in each controller
    redisKey = "/services/#{uid}#{JSON.stringify query}"
    redis.get redisKey, (err, data) ->
      if data
        callback eval data
      else
        # Cache is clean, go grab it from mongo    
        if uid
          # Find a single service
          Service.findOne { uid: uid }, (err, data) ->
            if err
              console.log err
            else
              redis.set redisKey, JSON.stringify data
              callback data
        else
          # Show all services
          options = {} 
          options.limit = 20                 
          if query.page
            options.skip = options.limit * query.page
                      
          Service.find {}, [], options, (err, data) =>
            if err
              console.log err
            else
              redis.set redisKey, JSON.stringify data
              callback data    
    
  set: (json, callback) ->
    # Add a service given some json
    # Callback should be error or no callback if successful
    service = new Service json

    Service.findOne { uid: service.uid }, (err, data) ->
      if !data
        # Does not exist, save it!
        service.save (err) ->
          if err
            console.log err
    
  update: (id) ->
    
  remove: (id) ->