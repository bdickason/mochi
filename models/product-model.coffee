### Product db model ###

# Contains all relevant info about any PRODUCTS involved in the biz
# e.g. a product could be a shampoo called 'DF' by Aestelance
#      a product could be a vintage coke bottle that Clarissa found

cfg = require '../config/config.js'    # contains API keys, etc.
mongoose = require 'mongoose'

Schema = mongoose.Schema
ObjectId = Schema.ObjectId


### Embedded Doc - A product can have one brand ###
# Note: I _THINK_ this should be an embedded doc but not sure.
#       Although most products have a brand, some do not, and most of the time
#       the product itself will be the index, not the brand.
#       Eventually we may build this out but for now its just a name

Brand = new Schema {
  name: { type: String }
}

Category = new Schema {
  name: { type: String }
}

ProductSchema = new Schema {
  uid: { type: Number, required: true },
  name: { type: String, required: true },
  category: [Category],   # e.g. 'shampoo', 'cookbook', etc.
  brand: [Brand],         # e.g. 'Aestelance', 'Kevin Murphy', etc.
  price:
    retail: { type: Number },
    wholesale: { type: Number }
  size: { type: String },
  active: { type: Number },
  date_updated: { type: Date }
}

mongoose.model 'Products', ProductSchema
module.exports = db.model 'Products'
