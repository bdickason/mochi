(function() {
  /* Product db model */  var Brand, Category, ObjectId, ProductSchema, Schema, cfg, mongoose;
  cfg = require('../config/config.js');
  mongoose = require('mongoose');
  Schema = mongoose.Schema;
  ObjectId = Schema.ObjectId;
  /* Embedded Doc - A product can have one brand */
  Brand = new Schema({
    name: {
      type: String
    }
  });
  Category = new Schema({
    name: {
      type: String
    }
  });
  ProductSchema = new Schema({
    uid: {
      type: Number,
      required: true
    },
    name: {
      type: String,
      required: true
    },
    category: [Category],
    brand: [Brand],
    price: {
      retail: {
        type: Number
      },
      wholesale: {
        type: Number
      }
    },
    size: {
      type: String
    },
    active: {
      type: Number
    },
    date_updated: {
      type: Date
    }
  });
  mongoose.model('Products', ProductSchema);
  module.exports = db.model('Products');
}).call(this);
