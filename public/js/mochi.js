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
        '!/salesTax/:startDate/:endDate': 'salesTax',
        '!/newClients/:startDate/:stylist': 'newClients',
        '!/newClients/:startDate': 'newClients'
      };
      Routes.prototype.salesTax = function(startDate, endDate) {
        window.salesTax = new SalesTax;
        return window.salesTaxView = new SalesTaxView({
          collection: salesTax
        });
      };
      Routes.prototype.newClients = function(startDate, stylist) {
        window.reportView = new ReportView({
          el: $('.containerOuter')
        });
        window.newClients = new NewClients({
          startDate: startDate,
          stylist: stylist
        });
        window.selectStylist = new SelectStylist({
          el: $('.srchResult'),
          collection: newClients
        });
        return window.newClientsView = new NewClientsView({
          el: $('.listingContainer'),
          collection: newClients
        });
      };
      return Routes;
    })();
    routes = new Routes;
    return Backbone.history.start();
  });
}).call(this);
