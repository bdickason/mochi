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
    /* Loaders */    var routes;
    $(".chzn-select").chosen();
    window.Routes = (function() {
      __extends(Routes, Backbone.Router);
      function Routes() {
        Routes.__super__.constructor.apply(this, arguments);
      }
      Routes.prototype.routes = {
        '!/salesTax/:startDate/:endDate': 'salesTax',
        '!/newClients/:startDate': 'newClients',
        '!/newClients/:startDate/:stylist': 'newClients'
      };
      Routes.prototype.salesTax = function(startDate, endDate) {
        console.log('worked!');
        console.log(startDate);
        window.salesTax = new SalesTax;
        return window.salesTaxView = new SalesTaxView({
          collection: salesTax
        });
      };
      Routes.prototype.newClients = function(startDate, stylist) {
        console.log('worked!');
        console.log(startDate);
        window.newClients = new NewClients({
          startDate: startDate
        });
        return window.newClientsView = new NewClientsView({
          collection: newClients
        });
      };
      return Routes;
    })();
    routes = new Routes;
    return Backbone.history.start();
  });
}).call(this);
