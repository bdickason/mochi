(function() {
  var User, Users, cfg;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  cfg = require('../config/config');
  User = require('../models/user-model');
  exports.Users = Users = (function() {
    function Users() {}
    Users.prototype.get = function(uid, query, callback) {
      var redisKey;
      console.log(uid);
      redisKey = "/users/" + uid + (JSON.stringify(query));
      return redis.get(redisKey, function(err, data) {
        var options;
        if (data) {
          return callback(JSON.parse(data));
        } else {
          if (uid) {
            return User.findOne({
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
            return User.find({}, [], options, __bind(function(err, data) {
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
    Users.prototype.set = function(json, callback) {
      var user;
      user = new User(json);
      return User.findOne({
        uid: user.uid
      }, function(err, data) {
        if (!data) {
          return user.save(function(err) {
            if (err) {
              return console.log(err);
            }
          });
        }
      });
    };
    Users.prototype.update = function(id) {};
    Users.prototype.remove = function(id) {};
    return Users;
  })();
}).call(this);
