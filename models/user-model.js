(function() {
  /* Users db model */  var Note, ObjectId, Phone, Schema, Stylist, UserSchema, cfg, mongoose;
  cfg = require('../config/config.js');
  mongoose = require('mongoose');
  Schema = mongoose.Schema;
  ObjectId = Schema.ObjectId;
  /* Embedded Doc - A user can have many phone numbers */
  Phone = new Schema({
    number: {
      type: String
    },
    type: {
      type: String
    }
  });
  /* Embedded Doc - A user can have many notes */
  Note = new Schema({
    date: {
      type: Date
    },
    message: {
      type: String
    },
    author: {
      type: String
    }
  });
  /* Embedded Doc - A user can have many stylists */
  Stylist = new Schema({
    id: {
      type: Number
    },
    type: {
      type: String
    }
  });
  UserSchema = new Schema({
    /* Client Stuff (all users) */
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
    birthday: {
      type: Date
    },
    gender: {
      type: String
    },
    address: {
      street: {
        type: String
      },
      apartment: {
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
    phone: [Phone],
    notes: [Note],
    referral: {
      type: String
    },
    stylist: [Stylist],
    /* Stylist stuff goes below here */
    ssn: {
      type: String
    },
    employee: {
      type: Boolean
    },
    password: {
      hash: {
        type: String
      },
      salt: {
        type: String
      }
    },
    /* System stuff goes below here */
    active: {
      type: Number,
      "default": 1
    },
    date_added: {
      type: Date
    },
    date_updated: {
      type: Date
    },
    last_transaction_date: {
      type: Date
    },
    type: {
      type: String
    },
    permissions: {
      type: String
    }
  });
  mongoose.model('Users', UserSchema);
  module.exports = db.model('Users');
}).call(this);
