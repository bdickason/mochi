(function() {
  /* Report class */  window.Report = (function() {
    function Report(data) {
      this.data = data;
    }
    Report.prototype.render = function() {
      var source, template;
      source = $('#salesTax-template').html();
      template = Handlebars.compile(source);
      return $('.userWrapper').html(template(this.data));
    };
    return Report;
  })();
}).call(this);
