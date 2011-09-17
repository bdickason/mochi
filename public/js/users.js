(function() {
  /* Users class */  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  $(function() {
    window.User = (function() {
      __extends(User, Backbone.Model);
      function User() {
        User.__super__.constructor.apply(this, arguments);
      }
      return User;
    })();
    /* users - Base collection */
    window.Users = (function() {
      __extends(Users, Backbone.Collection);
      function Users() {
        Users.__super__.constructor.apply(this, arguments);
      }
      Users.prototype.model = User;
      Users.prototype.url = '/api/users';
      Users.prototype.isAdmin = function(uid) {
        if (this.model.get('type') === 'administrator') {
          return true;
        } else {
          return false;
        }
      };
      return Users;
    })();
    /* Stylists  */
    window.Stylists = (function() {
      __extends(Stylists, Users);
      function Stylists() {
        Stylists.__super__.constructor.apply(this, arguments);
      }
      return Stylists;
    })();
    /* Clients */
    return window.Clients = (function() {
      __extends(Clients, Users);
      function Clients() {
        Clients.__super__.constructor.apply(this, arguments);
      }
      return Clients;
    })();
  });
}).call(this);
