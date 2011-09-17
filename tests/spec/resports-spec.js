(function() {
  /* Reports Tests */  var App, basedir;
  basedir = '../../';
  App = require(basedir + 'app.js');
  require((basedir + 'reports').Reports);
  describe('Daily Sales Report', function() {
    return it('Accepts a date');
  });
}).call(this);
