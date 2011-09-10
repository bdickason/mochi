(function() {
  var Appointment, Appointments, cfg;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  cfg = require('../config/config');
  Appointment = require('../models/appointment-model');
  exports.Appointments = Appointments = (function() {
    function Appointments() {}
    Appointments.prototype.get = function(uid, query, callback) {
      var redisKey;
      redisKey = "/appointments/" + uid + (JSON.stringify(query));
      return redis.get(redisKey, function(err, data) {
        var options;
        if (data) {
          return callback(eval(data));
        } else {
          if (uid) {
            return Appointment.findOne({
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
            return Appointment.find({}, [], options, __bind(function(err, data) {
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
    Appointments.prototype.set = function(json, callback) {
      var appointment;
      appointment = new Appointment(json);
      return Appointment.findOne({
        uid: appointment.uid
      }, function(err, data) {
        if (!data) {
          return appointment.save(function(err) {
            if (err) {
              return console.log(err);
            }
          });
        }
      });
    };
    Appointments.prototype.update = function(id) {};
    Appointments.prototype.remove = function(id) {};
    return Appointments;
  })();
}).call(this);
