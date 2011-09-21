(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  $(function() {
    /* New Clients Report */    window.NewClients = (function() {
      __extends(NewClients, Reports);
      function NewClients() {
        NewClients.__super__.constructor.apply(this, arguments);
      }
      NewClients.prototype.initialize = function(params) {
        if (params.startDate) {
          this.startDate = params.startDate;
        }
        return this.setStylist(params.stylist);
      };
      NewClients.prototype.setStylist = function(stylist) {
        if (stylist && stylist !== 'null') {
          this.stylist = stylist;
          return this.url = "/api/reports/newClients/" + this.startDate + "/" + this.stylist;
        } else {
          delete this.stylist;
          return this.url = "/api/reports/newClients/" + this.startDate;
        }
      };
      return NewClients;
    })();
    /* New Client report View */
    return window.NewClientsView = (function() {
      __extends(NewClientsView, Backbone.View);
      function NewClientsView() {
        NewClientsView.__super__.constructor.apply(this, arguments);
      }
      NewClientsView.prototype.initialize = function() {
        var source;
        this.el = $('.listingContainer');
        _.bindAll(this, 'render');
        this.collection.bind('reset', this.render);
        this.collection.bind('all', this.debug);
        source = $('#newClients-template').html();
        this.template = Handlebars.compile(source);
        return this.collection.fetch();
      };
      NewClientsView.prototype.render = function() {
        var renderedContent;
        renderedContent = this.template({
          report: this.collection.toJSON()
        });
        $(this.el).html(renderedContent);
        return this;
      };
      NewClientsView.prototype.debug = function(e) {
        return console.log("Fired event: " + e);
      };
      return NewClientsView;
    })();
  });
}).call(this);
