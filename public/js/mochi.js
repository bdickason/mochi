(function() {
  /* Main client-side application code */  $(function() {
    window.report = new Daily({
      dates: {
        start: 'blah',
        end: 'blah2'
      }
    });
    window.reports = new Reports;
    return window.reportView = new ReportView({
      collection: reports
    });
  });
}).call(this);
