### Service db model ###

# Contains all relevant info about any SERVICES involved in the biz
# e.g. a client coult get a blowout before a night out
#      a dude could get a sweet haircut with lightning bolts in it

cfg = require '../config/config.js'    # contains API keys, etc.
mongoose = require 'mongoose'

Schema = mongoose.Schema
ObjectId = Schema.ObjectId


ServiceSchema = new Schema {
  uid: { type: Number, required: true },
  name: { type: String, required: true }, 
  price:
    retail: { type: Number },
  active: { type: Number },
}

mongoose.model 'Services', ServiceSchema
module.exports = db.model 'Services'
