(function() {
  var Service, Services, cfg;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  cfg = require('../config/config');
  Service = require('../models/service-model');
  exports.Services = Services = (function() {
    function Services() {}
    Services.prototype.get = function(uid, query, callback) {
      var redisKey;
      redisKey = "/services/" + uid + (JSON.stringify(query));
      return redis.get(redisKey, function(err, data) {
        var options;
        if (data) {
          return callback(eval(data));
        } else {
          if (uid) {
            return Service.findOne({
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
            return Service.find({}, [], options, __bind(function(err, data) {
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
    Services.prototype.set = function(json, callback) {
      var service;
      service = new Service(json);
      return Service.findOne({
        uid: service.uid
      }, function(err, data) {
        if (!data) {
          return service.save(function(err) {
            if (err) {
              return console.log(err);
            }
          });
        }
      });
    };
    Services.prototype.update = function(id) {};
    Services.prototype.remove = function(id) {};
    return Services;
  })();
}).call(this);
