(function() {
  /* Appointment db model */  var AppointmentSchema, ObjectId, Payment, Schema, Transaction, cfg, mongoose;
  cfg = require('../config/config.js');
  mongoose = require('mongoose');
  Schema = mongoose.Schema;
  ObjectId = Schema.ObjectId;
  /* Embedded Doc - An Appointment can have many payments */
  Payment = new Schema({
    type: String,
    amount: Number
  });
  /* Embedded Doc - An appointment can have many transactions */
  Transaction = new Schema({
    uid: {
      type: Number,
      required: true
    },
    client: {
      type: Number,
      required: true
    },
    stylist: {
      type: Number
    },
    service: {
      id: Number,
      price: Number
    },
    product: {
      id: Number,
      quantity: Number,
      price: Number
    },
    date: {
      start: Date,
      end: Date,
      updated: Date
    },
    author: Number,
    completed: Boolean
  });
  AppointmentSchema = new Schema({
    uid: {
      type: Number,
      unique: true
    },
    transactions: [Transaction],
    payments: [Payment],
    paid: {
      Boolean: Boolean,
      "default": false
    },
    active: {
      type: Number,
      "default": 1
    },
    confirmed: Boolean,
    total: Number,
    "void": {
      "void": {
        type: Boolean,
        "default": false
      },
      date: Date,
      user: Number
    }
  });
  mongoose.model('Appointments', AppointmentSchema);
  module.exports = db.model('Appointments');
}).call(this);
