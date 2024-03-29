### Users db model ###

# Contains all relevant info about any PEOPLE involved in the biz
# e.g. a user could be a client named John Smith
#      a user could be a stylist named Clarissa Malek
#      a user could be an admin named Tivs!

cfg = require '../config/config.js'    # contains API keys, etc.
mongoose = require 'mongoose'

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

### Embedded Doc - A user can have many phone numbers ###
Phone = new Schema {
  number: { type: String },
  type: { type: String },
}

### Embedded Doc - A user can have many notes ###
Note = new Schema {
  date: { type: Date },
  message: { type: String },
  author: { type: String }
}

### Embedded Doc - A user can have many stylists ###
Stylist = new Schema { 
  id: { type: Number },
  type: { type: String}   # Cut, color, etc.
}


UserSchema = new Schema {
  ### Client Stuff (all users) ###
  uid: { type: Number, unique: true},
  name: { type: String, required: true },
  email: { type: String },
  birthday: { type: Date },
  gender: { type: String },
  address: {
    street: { type: String },
    apartment: { type: String },
    city: { type: String },
    state: { type: String },
    country: { type: String },
    zip: { type: String },
  },
  phone: [Phone],  
  
  notes: [Note],                  # A user can have many notes
  
  referral: { type: String },     # Who referred this stylist
  
  stylist: [Stylist],
  
  ### Stylist stuff goes below here ###
  ssn: { type: String },
  employee: { type: Boolean },    # Some stylists are employees (W-2) some are contractors (W-9)

  password: {
    hash: { type: String },
    salt: { type: String },
  },
      
  ### System stuff goes below here ###
  active: { type: Number, default: 1 },
  date_added: { type: Date },
  date_updated: { type: Date },
  last_transaction_date: { type: Date },
  
  type: { type: String },         # Remove this eventually. Type = administrator, client, stylist?
  permissions: { type: String },  # Remove this eventually. Permissions = administrator, NULL
}

mongoose.model 'Users', UserSchema
module.exports = db.model 'Users'