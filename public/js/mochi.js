(function() {
  /* Main client-side application code */  $(function() {
    window.Daily = Backbone.Model.extend({});
    window.ReportView = Backbone.View.extend({
      tagName: 'div',
      className: 'userWrapper',
      initialize: function() {
        var source;
        _.bindAll(this, 'render');
        this.model.bind('change', this.render);
        source = $('#salesTax-template').html();
        return this.template = Handlebars.compile(source);
      },
      render: function() {
        var renderedContent;
        renderedContent = this.template(this.model.toJSON());
        $(this.el).html(renderedContent);
        return this;
      }
    });
    window.report = new Daily({
      dates: {
        start: 'blah',
        end: 'blah2'
      }
    });
    return window.reportView = new ReportView({
      model: report
    });
  });
}).call(this);
