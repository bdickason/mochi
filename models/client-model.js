(function() {
  /* Client Schema
      -Every user is a client
      -Some clients are stylists */  var ClientSchema, ObjectId, Schema, cfg, mongoose;
  cfg = require('../config/config.js');
  mongoose = require('mongoose');
  Schema = mongoose.Schema;
  ObjectId = Schema.ObjectId;
  ClientSchema = new Schema({
    uid: {
      type: Number,
      unique: true
    },
    name: {
      type: String,
      required: true
    },
    email: {
      type: String
    },
    birthdate: {
      type: Date
    },
    gender: {
      type: String
    },
    address: {
      street: {
        type: String
      },
      apt: {
        type: String
      },
      city: {
        type: String
      },
      state: {
        type: String
      },
      country: {
        type: String
      },
      zip: {
        type: String
      }
    },
    phone: [],
    stylist: {
      cut: {
        type: String
      },
      color: {
        type: String
      }
    },
    notes: [],
    referral: {
      type: String
    },
    last_transaction: {
      type: String
    },
    date_added: {
      type: Date,
      required: true
    },
    date_updated: {
      type: Date,
      required: true
    },
    active: {
      type: Number,
      required: true,
      "default": 1
    },
    type: {
      type: String,
      required: true,
      "default": 'client'
    },
    /* Admin stuffs  */
    password_hash: {
      type: String
    },
    password_salt: {
      type: String
    },
    ssn: {
      type: String
    }
  });
  mongoose.model('Client', ClientSchema);
  module.exports = db.model('Client');
}).call(this);
