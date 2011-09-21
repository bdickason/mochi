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
    /* Sales Tax Report */    window.SalesTax = (function() {
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
    return window.SalesTaxView = (function() {
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
  });
}).call(this);
