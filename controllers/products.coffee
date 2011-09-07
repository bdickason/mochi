cfg = require '../config/config'    # contains API keys, etc.
 
# Initialize Products Model
Product = require '../models/product-model'

exports.Products = class Products

  get: (uid, callback) ->
    # Always check cache first - this should eventually go in each controller
    redisKey = "/products/#{uid}"
    redis.get redisKey, (err, data) ->
      if data
        callback eval data
      else
        # Cache is clean, go grab it from mongo    
        if uid
          # Find a single product
          Product.find { uid: uid }, (err, data) ->
            if err
              console.log err
            else
              redis.set redisKey, JSON.stringify data
              callback data
        else
          # Show all products
          Product.find {}, (err, data) =>
            if err
              console.log err
            else
              redis.set redisKey, JSON.stringify data
              callback data
    
  set: (json, callback) ->
    # Add a product given some json
    # Callback should be error or no callback if successful
    product = new Product json 

    Product.find {uid: product.uid}, (err, data) ->
      if data.length is 0
        # Does not exist, save it!
        product.save (err) ->
          if err
            console.log err
                
  update: (id) ->
    
  remove: (id) ->