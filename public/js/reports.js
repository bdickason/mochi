(function() {
  $(function() {
    /* Report Model for Backbone.js */    window.salesTaxReport = Backbone.Model.extend({
      initialize: function(report) {
        return this.set(report);
      }
    });
    window.Reports = Backbone.Collection.extend({
      model: salesTaxReport,
      url: '/#!/reports'
    });
    window.reports = new Reports;
    window.ReportView = Backbone.View.extend({
      initialize: function() {
        _.bindAll(this, 'render');
        return this.model.bind('change', this.render);
      },
      tagName: 'li',
      events: {
        'change .datePicker': 'changeDate'
      },
      changeDate: function() {
        return console.log('New Date: ' + this.input.val());
      },
      render: function() {
        $(this.el).html(this.model.toJSON());
        return this;
      }
    });
    window.AppView = Backbone.View.extend({
      el: $('#content'),
      initialize: function() {
        _.bindAll(this, 'render');
        return reports.fetch();
      }
    });
    return window.App = new AppView;
  });
}).call(this);
