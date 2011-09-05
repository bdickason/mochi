cfg = require '../config/config'    # contains API keys, etc.
 
# Initialize Products Model
Product = require '../models/product-model'

exports.Products = class Products

  get: (callback) ->
    # Show all products
    Product.find {}, (err, data) =>
      if err
        console.log err
      else
        callback data
    
  set: (json, callback) ->
    # Add a product given some json
    # Callback should be error or no callback if successful
    product = new Product json
    console.log product

    product.save (err) ->
      if err
        console.log err
    
  update: (id) ->
    
  remove: (id) ->