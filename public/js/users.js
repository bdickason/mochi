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
    window.Stylist = (function() {
      __extends(Stylist, User);
      function Stylist() {
        Stylist.__super__.constructor.apply(this, arguments);
      }
      return Stylist;
    })();
    window.Stylists = (function() {
      __extends(Stylists, Users);
      function Stylists() {
        Stylists.__super__.constructor.apply(this, arguments);
      }
      Stylists.prototype.initialize = function(params) {
        return this.url = "/api/stylists/" + params.stylist;
      };
      return Stylists;
    })();
    /*
      # Select Stylist dropdown
      # Grabs a list of stylists (Stylists) and lets the user select one to update a form
      # Made sexier with Chosen
      class window.StylistSelector extends Backbone.View
        tagName: 'div'
        className: 'srchResult'
    
        initialize: ->
         @el = '.srchResult' 
         _.bindAll this, 'render'
         @collection.bind 'reset', @render
    
         # Compile Handlebars template at init (Not sure if we have to do this each time or not)
         source = $('#newClients-template').html()
         @template = Handlebars.compile source
    
         # Get the latest collections
         @collection.fetch()
    
        render: ->
         # Render Handlebars template
         console.log 'rendering!'
         console.log @collection.toJSON()
         renderedContent = @template { report: @collection.toJSON() }
         $(@el).html renderedContent
         return this
      */
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
