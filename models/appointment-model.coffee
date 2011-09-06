### Appointment db model ###

# Contains all relevant info about any interactions involved in the biz
# e.g. a user could make an appointment with a stylist for a haircut
#      a user could get a blowout from a stylist and pay for it
#      a user could schedule an appointment with a stylist and not show up

cfg = require '../config/config.js'    # contains API keys, etc.
mongoose = require 'mongoose'

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

### Embedded Doc - An appointment can have many transactions ###
Transaction = new Schema {
  # A transaction is between one stylist and one user on a given checkout
  # A transaction can be for a service or a product
  # Exception: If a product is sold by the 'house' it has no stylist.
  
  uid: { type: Number, required: true },

  client: { type: Number, required: true },   # Client ID
  stylist: { type: Number },
  
  service: 
    id: Number,  # Service ID  (optional)
    price: Number
  product: 
    id: Number,  # Product ID  (optional)
    quantity: Number,
    price: Number

  date:
    start: Date,
    end: Date,
    updated: Date
      
  payment: String,

  author: Number,
  completed: Boolean,  # Checkout is completed and paid for!
    
  void: 
    void: {type: Boolean, default: false }  # Couldn't come up with a better name :\
    date: Date,
    user: Number      
}

AppointmentSchema = new Schema {
  uid: Number,
  transactions: [Transaction],
  active: Number,
  confirmed: Boolean  # Did the receptionist confirm it?
}

mongoose.model 'Appointments', AppointmentSchema
module.exports = db.model 'Appointments'