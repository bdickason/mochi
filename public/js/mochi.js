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
    var routes;
    window.Routes = (function() {
      __extends(Routes, Backbone.Router);
      function Routes() {
        Routes.__super__.constructor.apply(this, arguments);
      }
      Routes.prototype.routes = {
        '!/daily/:startDate': 'daily'
      };
      Routes.prototype.daily = function(startDate) {
        console.log('worked!');
        window.report = new Daily({});
        window.reports = new Reports;
        return window.reportView = new ReportView({
          collection: reports
        });
      };
      return Routes;
    })();
    routes = new Routes;
    return Backbone.history.start();
  });
}).call(this);
