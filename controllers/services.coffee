cfg = require '../config/config'    # contains API keys, etc.
 
# Initialize Products Model
Service = require '../models/service-model'

exports.Services = class Services

  get: (callback) ->
    # Show all services
    Service.find {}, (err, data) =>
      if err
        console.log err
      else
        callback data
    
  set: (json, callback) ->
    # Add a service given some json
    # Callback should be error or no callback if successful
    service = new Service json

    console.log service
    service.save (err) ->
      if err
        console.log err
    
  update: (id) ->
    
  remove: (id) ->