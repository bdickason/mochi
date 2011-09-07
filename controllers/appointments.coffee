cfg = require '../config/config'    # contains API keys, etc.
 
# Initialize Appointment Model
Appointment = require '../models/appointment-model'

exports.Appointments = class Appointments

  get: (uid, callback) ->
    # Always check cache first - this should eventually go in each controller
    redisKey = "/appointments/#{uid}"
    redis.get redisKey, (err, data) ->
      if data
        callback eval data
      else
        # Cache is clean, go grab it from mongo
        if uid
          # Find a single Appointment
          Appointment.find { uid: uid }, (err, data) ->
            if err
              console.log err
            else
              redis.set redisKey, JSON.stringify data
              callback data
        else
          # Show all appointments
          Appointment.find {}, (err, data) =>
            if err
              console.log err
            else
              redis.set redisKey, JSON.stringify data
              callback data
  
  set: (json, callback) ->
    # Add an appointment given some json
    # Callback should be error or no callback if successful
    appointment = new Appointment json
    
    # Check to make sure it doesn't exist
    Appointment.find {uid: appointment.uid}, (err, data) ->
      if data.length is 0
        # Does not exist, save it!
        appointment.save (err) ->
          if err
            console.log err
    
  update: (id) ->
    
  remove: (id) ->