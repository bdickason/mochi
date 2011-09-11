(function() {
  $(function() {
    /* Report Model for Backbone.js */    window.salesTaxReport = Backbone.Model.extend({
      initialize: function(report) {
        return this.set(report);
      }
    });
    window.Reports = Backbone.Collection.extend({
      model: salesTaxReport,
      url: '/api/reports/salesTax/09-01-2011'
    });
    window.reports = new Reports;
    return reports.fetch();
    /*
      # Reports views
      window.ReportView = Backbone.View.extend
        initialize: ->
          # Make sure functions are called with the right scope
          _.bindAll this, 'render'
          
          # Listen to model changes
          @model.bind 'change', @render
        
        tagName: 'li'
        # template: Handlebars.compile $('#salesTax-template').html()
      
        events: 
          'change .datePicker'  : 'changeDate'
      
        changeDate: ->
          console.log 'New Date: ' + @input.val()
          
        render: ->
          # $(@el).html @template @model.toJSON()
          $(@el).html @model.toJSON()
          return this
    
      window.AppView = Backbone.View.extend
        el: $('#content')
    
        initialize: ->
          _.bindAll this, 'render'
          
          reports.fetch()
    
      window.App = new AppView */
  });
}).call(this);
