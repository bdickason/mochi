cfg = require '../config/config'    # contains API keys, etc.
 
# Initialize Appointment Model
Appointment = require '../models/appointment-model'

exports.Appointments = class Appointments

  get: (uid, callback) ->
    if uid
      # Find a single Appointment
      Appointment.find { uid: uid }, (err, data) ->
        if err
          console.log err
        else
          console.log data
          callback data
    else
      # Show all appointments
      Appointment.find {}, (err, data) =>
        if err
          console.log err
        else
          callback data
  
  set: (json, callback) ->
    # Add an appointment given some json
    # Callback should be error or no callback if successful
    appointment = new User json

    appointment.save (err) ->
      if err
        console.log appointment
        console.log err
    
  update: (id) ->
    
  remove: (id) ->