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
    /* Simple report model */    window.Report = (function() {
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
