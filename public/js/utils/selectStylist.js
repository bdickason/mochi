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
    /* Utility - Stylist Dropdown */    return window.SelectStylist = (function() {
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
        source = $('#selectStylist-template').html();
        return this.template = Handlebars.compile(source);
      };
      SelectStylist.prototype.render = function() {
        var renderedContent;
        renderedContent = this.template({
          report: this.collection.toJSON()
        });
        $(this.el).html(renderedContent);
        $('.chzn-select').chosen();
        return this.collection.unbind('reset', this.render);
      };
      SelectStylist.prototype.selectStylist = function(e) {
        this.collection.setStylist($(e.currentTarget).val());
        return this.collection.fetch();
      };
      return SelectStylist;
    })();
  });
}).call(this);
