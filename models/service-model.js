(function() {
  /* Service db model */  var ObjectId, Schema, ServiceSchema, cfg, mongoose;
  cfg = require('../config/config.js');
  mongoose = require('mongoose');
  Schema = mongoose.Schema;
  ObjectId = Schema.ObjectId;
  ServiceSchema = new Schema({
    uid: {
      type: Number,
      required: true
    },
    name: {
      type: String,
      required: true
    },
    price: {
      retail: {
        type: Number
      }
    },
    active: {
      type: Number
    }
  });
  mongoose.model('Services', ServiceSchema);
  module.exports = db.model('Services');
}).call(this);
