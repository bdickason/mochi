(function() {
  /* Main client-side application code */  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  $(function() {
    window.Daily = Backbone.Model.extend({});
    window.Reports = (function() {
      __extends(Reports, Backbone.Collection);
      function Reports() {
        Reports.__super__.constructor.apply(this, arguments);
      }
      Reports.prototype.model = Daily;
      Reports.prototype.url = '/api/reports/salesTax/06-01-2011/08-31-2011';
      return Reports;
    })();
    window.ReportView = (function() {
      __extends(ReportView, Backbone.View);
      function ReportView() {
        ReportView.__super__.constructor.apply(this, arguments);
      }
      ReportView.prototype.tagName = 'div';
      ReportView.prototype.className = 'userWrapper';
      ReportView.prototype.initialize = function() {
        var source;
        this.el = '.userWrapper';
        _.bindAll(this, 'render');
        this.collection.bind('reset', this.render);
        this.model.view = this;
        source = $('#salesTax-template').html();
        this.template = Handlebars.compile(source);
        return this.collection.fetch();
      };
      ReportView.prototype.render = function() {
        var renderedContent;
        console.log('rendering!');
        renderedContent = this.template(this.model.toJSON());
        $(this.el).html(renderedContent);
        return this;
      };
      return ReportView;
    })();
    window.report = new Daily({
      dates: {
        start: 'blah',
        end: 'blah2'
      }
    });
    window.reports = new Reports;
    return window.reportView = new ReportView({
      model: report,
      collection: reports
    });
  });
}).call(this);
