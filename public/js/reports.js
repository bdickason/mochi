(function() {
  /* Report class */  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  $(function() {
    /* Master view for the Report class */    var ReportView;
    ReportView = (function() {
      __extends(ReportView, Backbone.View);
      function ReportView() {
        ReportView.__super__.constructor.apply(this, arguments);
      }
      ReportView.prototype.initialize = function(params) {
        switch (params.type) {
          case 'newClients':
            return console.log('new clients');
          case 'daily':
            return console.log('daily');
        }
      };
      return ReportView;
    })();
    /* Simple report model */
    window.Report = (function() {
      __extends(Report, Backbone.Model);
      function Report() {
        Report.__super__.constructor.apply(this, arguments);
      }
      return Report;
    })();
    /* Reports - Base collection for all reports */
    window.Reports = (function() {
      __extends(Reports, Backbone.Collection);
      function Reports() {
        Reports.__super__.constructor.apply(this, arguments);
      }
      Reports.prototype.model = Report;
      return Reports;
    })();
    /* Sales Tax Report */
    window.SalesTax = (function() {
      __extends(SalesTax, Reports);
      function SalesTax() {
        SalesTax.__super__.constructor.apply(this, arguments);
      }
      SalesTax.prototype.initialize = function() {
        console.log(this.startDate);
        return this.url = "/api/reports/salesTax/06-01-2011/08-31-2011";
      };
      return SalesTax;
    })();
    window.SalesTaxView = (function() {
      __extends(SalesTaxView, Backbone.View);
      function SalesTaxView() {
        SalesTaxView.__super__.constructor.apply(this, arguments);
      }
      SalesTaxView.prototype.tagName = 'div';
      SalesTaxView.prototype.className = 'containerOuter';
      SalesTaxView.prototype.initialize = function() {
        var source;
        this.el = '.containerOuter';
        _.bindAll(this, 'render');
        this.collection.bind('reset', this.render);
        source = $('#salesTax-template').html();
        this.template = Handlebars.compile(source);
        return this.collection.fetch();
      };
      SalesTaxView.prototype.render = function() {
        var renderedContent;
        console.log('rendering!');
        console.log(this.collection.toJSON());
        renderedContent = this.template({
          report: this.collection.toJSON()
        });
        $(this.el).html(renderedContent);
        return this;
      };
      return SalesTaxView;
    })();
    /* New Clients Report */
    window.NewClients = (function() {
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
    window.NewClientsView = (function() {
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
        console.log('rendering!');
        console.log(this.collection.toJSON());
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
    window.SelectStylist = (function() {
      __extends(SelectStylist, Backbone.View);
      function SelectStylist() {
        SelectStylist.__super__.constructor.apply(this, arguments);
      }
      SelectStylist.prototype.events = {
        'change #stylists': 'selectStylist'
      };
      SelectStylist.prototype.initialize = function() {
        var source;
        this.el = $('.srchResult');
        _.bindAll(this, 'render');
        this.collection.bind('reset', this.render);
        this.collection.bind('all', this.debug);
        source = $('#selectStylist-template').html();
        return this.template = Handlebars.compile(source);
      };
      SelectStylist.prototype.render = function() {
        var renderedContent;
        console.log(this.collection);
        renderedContent = this.template({
          report: this.collection.toJSON()
        });
        $(this.el).html(renderedContent);
        return $('.chzn-select').chosen();
      };
      SelectStylist.prototype.selectStylist = function(e) {
        this.collection.setStylist($(e.currentTarget).val());
        return this.collection.fetch();
      };
      return SelectStylist;
    })();
    return window.ReportView = (function() {
      __extends(ReportView, Backbone.View);
      function ReportView() {
        ReportView.__super__.constructor.apply(this, arguments);
      }
      ReportView.prototype.initialize = function() {
        var source;
        this.el = $('.containerOuter');
        _.bindAll(this, 'render');
        source = $('#report-template').html();
        this.template = Handlebars.compile(source);
        return this.render();
      };
      ReportView.prototype.render = function() {
        var renderedContent;
        console.log('got here');
        renderedContent = this.template({});
        return $(this.el).html(renderedContent);
      };
      return ReportView;
    })();
  });
}).call(this);
