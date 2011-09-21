(function() {
  var Import, cfg, http;
  http = require('http');
  cfg = require('../../config/config.js');
  exports.Import = Import = (function() {
    function Import() {
      this.options = {
        host: 'bloom.getmochi.com',
        port: 80,
        method: 'GET'
      };
    }
    Import.prototype.users = function(callback) {
      this.options.path = "http://bloom.getmochi.com/api/users/?secret=" + cfg.MOCHI_KEY + "&format=json&action=list&num=10000";
      return this.getRequest(callback);
    };
    Import.prototype.userOptions = function(callback) {
      this.options.path = "http://bloom.getmochi.com/api/users_options/?secret=" + cfg.MOCHI_KEY + "&format=json&action=list&num=10000";
      return this.getRequest(callback);
    };
    Import.prototype.products = function(callback) {
      this.options.path = "http://bloom.getmochi.com/api/products/?action=list&format=JSON&secret=" + cfg.MOCHI_KEY + "&num=2000";
      return this.getRequest(callback);
    };
    Import.prototype.services = function(callback) {
      this.options.path = "http://bloom.getmochi.com/api/services/?action=list&format=JSON&secret=" + cfg.MOCHI_KEY + "&num=2000";
      return this.getRequest(callback);
    };
    Import.prototype.transactions = function(callback) {
      this.options.path = "http://bloom.getmochi.com/api/transactions/?action=list&format=JSON&secret=" + cfg.MOCHI_KEY + "&num=50000";
      return this.getRequest(callback);
    };
    Import.prototype.transactionEntries = function(callback) {
      this.options.path = "http://bloom.getmochi.com/api/transactionEntries/?action=list&format=JSON&secret=" + cfg.MOCHI_KEY + "&num=50000";
      return this.getRequest(callback);
    };
    /* API: 'GET' */
    Import.prototype.getRequest = function(callback) {
      var tmp, _options;
      _options = this.options;
      tmp = [];
      return http.request(_options, function(res) {
        res.setEncoding('utf8');
        res.on('data', function(chunk) {
          return tmp.push(chunk);
        });
        return res.on('end', function(e) {
          var body;
          body = tmp.join('');
          return callback(JSON.parse(body));
        });
      }).end();
    };
    return Import;
  })();
}).call(this);
