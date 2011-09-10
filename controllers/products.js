(function() {
  var Product, Products, cfg;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  cfg = require('../config/config');
  Product = require('../models/product-model');
  exports.Products = Products = (function() {
    function Products() {}
    Products.prototype.get = function(uid, query, callback) {
      var redisKey;
      redisKey = "/products/" + uid + (JSON.stringify(query));
      return redis.get(redisKey, function(err, data) {
        var options;
        if (data) {
          return callback(eval(data));
        } else {
          if (uid) {
            return Product.findOne({
              uid: uid
            }, function(err, data) {
              if (err) {
                return console.log(err);
              } else {
                redis.set(redisKey, JSON.stringify(data));
                return callback(data);
              }
            });
          } else {
            options = {};
            options.limit = 20;
            if (query.page) {
              options.skip = options.limit * query.page;
            }
            return Product.find({}, [], options, __bind(function(err, data) {
              if (err) {
                return console.log(err);
              } else {
                redis.set(redisKey, JSON.stringify(data));
                return callback(data);
              }
            }, this));
          }
        }
      });
    };
    Products.prototype.set = function(json, callback) {
      var product;
      product = new Product(json);
      return Product.findOne({
        uid: product.uid
      }, function(err, data) {
        if (!data) {
          return product.save(function(err) {
            if (err) {
              return console.log(err);
            }
          });
        }
      });
    };
    Products.prototype.update = function(id) {};
    Products.prototype.remove = function(id) {};
    return Products;
  })();
}).call(this);
