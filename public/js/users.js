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
      Users.prototype.initialize = function(params) {
        if (params.id) {
          this.id = params.id;
          return this.url = "/api/users/" + this.id;
        }
      };
      Users.prototype.isAdmin = function(id) {
        if (this.model.get('type') === 'administrator') {
          return true;
        } else {
          return false;
        }
      };
      return Users;
    })();
    return window.UsersView = (function() {
      __extends(UsersView, Backbone.View);
      function UsersView() {
        UsersView.__super__.constructor.apply(this, arguments);
      }
      UsersView.prototype.initialize = function() {
        var source;
        this.el = $('.containerOuter');
        _.bindAll(this, 'render');
        this.collection.bind('reset', this.render);
        this.collection.bind('all', this.debug);
        source = $('#users-template').html();
        this.template = Handlebars.compile(source);
        return this.collection.fetch();
      };
      UsersView.prototype.render = function() {
        var renderedContent;
        renderedContent = this.template({
          user: this.collection.toJSON()
        });
        $(this.el).html(renderedContent);
        $('.chzn-select').chosen();
        return this;
      };
      UsersView.prototype.debug = function(e) {
        return console.log("Fired event: " + e);
      };
      return UsersView;
    })();
  });
}).call(this);
