(function() {
  var Appointments, Import, Products, Redis, RedisStore, Reports, Services, Users, app, cfg, doImport, express, getRoute, http, io, sys, url, winston;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  http = require('http');
  url = require('url');
  express = require('express');
  Redis = require('redis');
  RedisStore = (require('connect-redis'))(express);
  sys = require('sys');
  cfg = require('./config/config.js');
  winston = require('winston');
  global.logger = new winston.Logger({
    transports: [
      new winston.transports.Console({
        level: 'debug',
        colorize: true
      })
    ]
  });
  app = express.createServer();
  io = (require('socket.io')).listen(app);
  global.redis = Redis.createClient(cfg.REDIS_PORT, cfg.REDIS_HOSTNAME);
  redis.on('error', function(err) {
    return console.log('REDIS Error:' + err);
  });
  app.configure(function() {
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.register('.html', require('jade'));
    app.use(express.methodOverride());
    app.use(express.bodyParser());
    app.use(express.cookieParser());
    app.use(express.session({
      secret: cfg.SESSION_SECRET,
      store: new RedisStore,
      key: cfg.SESSION_ID
    }));
    app.use(app.router);
    return app.use(express.static(__dirname + '/public'));
  });
  app.dynamicHelpers({
    session: function(req, res) {
      return req.session;
    }
  });
  global.db = require('./models/db').db;
  /* Initialize controllers */
  Users = (require('./controllers/users')).Users;
  Products = (require('./controllers/products')).Products;
  Services = (require('./controllers/services')).Services;
  Appointments = (require('./controllers/appointments')).Appointments;
  Reports = (require('./controllers/reports')).Reports;
  Import = (require('./controllers/utils/import')).Import;
  app.get('/', function(req, res) {
    return res.render('index');
  });
  app.get('/favicon.ico', function(req, res) {});
  app.get('/import', function(req, res) {
    return doImport(req, res);
  });
  app.get('/api/reports/:report/:startDate?/:endDate?', function(req, res) {
    var report;
    report = new Reports;
    switch (req.params.report) {
      case 'daily':
        return report.daily(req.params.startDate, req.params.endDate, function(json) {
          return res.send(json);
        });
      case 'salesTax':
        return report.salesTax(req.params.startDate, req.params.endDate, function(json) {
          return res.send(json);
        });
    }
  });
  app.get('/api/:route/:uid?', function(req, res) {
    var obj;
    obj = getRoute(req.params.route);
    return obj.get(req.params.uid, req.query, function(json) {
      return res.send(json);
    });
  });
  /* Socket.io Stuff */
  io.enable('browser client minification');
  io.set('log level', 2);
  app.listen(process.env.PORT || 3000);
  /* Utility Functions */
  getRoute = function(route) {
    var obj;
    switch (route) {
      case 'appointments':
        obj = new Appointments;
        break;
      case 'products':
        obj = new Products;
        break;
      case 'services':
        obj = new Services;
        break;
      case 'users':
        obj = new Users;
        break;
      case 'reports':
        obj = new Reports;
    }
    return obj;
  };
  doImport = function(req, res) {
    var appointments, imp, impAppointments, impProducts, impServices, impTransactionEntries, impTransactions, products, services, users;
    users = new Users;
    imp = new Import;
    imp.users(__bind(function(json) {
      var imp2;
      imp2 = new Import;
      return imp.userOptions(__bind(function(optionsjson) {
        var entry, key, tmp_notes, user, value, _i, _j, _len, _len2, _ref, _ref2, _results;
        _ref = json.users;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          user = _ref[_i];
          for (key in user) {
            value = user[key];
            if (value === null || value === '') {
              delete user[key];
            }
            if (key === 'uid' || key === 'active') {
              user[key] = parseInt(value);
            }
          }
          user.phone = [];
          if (user.phone_primary_type === 'pager') {
            console.log('seriously?!');
          }
          if (user.phone_primary_number) {
            user.phone.push({
              number: user.phone_primary_number,
              type: user.phone_primary_type
            });
          }
          delete user.phone_primary_number;
          delete user.phone_primary_type;
          if (user.phone_secondary_number) {
            user.phone.push({
              number: user.phone_secondary_number,
              type: user.phone_secondary_type
            });
          }
          delete user.phone_secondary_number;
          delete user.phone_secondary_type;
          user.address = {};
          if (user.address_street) {
            user.address.street = user.address_street;
            delete user.address_street;
          }
          if (user.address_apartment) {
            user.address.apartment = user.address_apartment;
            delete user.address_apartment;
          }
          if (user.address_city) {
            user.address.city = user.address_city;
            delete user.address_city;
          }
          if (user.address_state) {
            user.address.state = user.address_state;
            delete user.address_state;
          }
          if (user.address_zip) {
            user.address.zip = user.address_zip;
            delete user.address_zip;
          }
          if (user.address_country) {
            user.address.country = user.address_country;
            delete user.address_country;
          }
          if (user.birthdate === '0000-00-00' || '1969-12-31') {
            delete user.birthdate;
          }
          if (user.password_salt) {
            user.password = {};
            user.password.salt = user.password_salt;
            delete user.password_salt;
          }
          if (user.password_hash) {
            user.password.hash = user.password_hash;
            delete user.password_hash;
          }
          if (user.notes) {
            tmp_notes = user.notes;
            delete user.notes;
            user.notes = [];
            user.notes.push({
              message: tmp_notes
            });
          }
          _ref2 = optionsjson.users;
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            entry = _ref2[_j];
            if (entry.uid === user.uid && entry.user_option_value !== 'none') {
              if (!user.stylist) {
                user.stylist = {};
              }
              if (entry.user_option_tag === 'salon_stylist_cut') {
                user.stylist.cut = parseInt(entry.user_option_value);
              } else if (entry.user_option_tag === 'salon_stylist_color') {
                user.stylist.color = parseInt(entry.user_option_value);
              }
            }
          }
          delete user.tax_info;
          user.active = 1;
          _results.push(user.name ? users.set(user, __bind(function(callback) {}, this)) : void 0);
        }
        return _results;
      }, this));
    }, this));
    products = new Products;
    impProducts = new Import;
    impProducts.products(__bind(function(json) {
      var brand_array, brand_first, product, _i, _len, _ref, _results;
      _ref = json.products;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        product = _ref[_i];
        brand_array = product.product_name.split(' ');
        brand_first = brand_array[0].toString();
        switch (brand_first) {
          case 'Simply':
          case 'Moroccan':
          case 'Kevin':
            product.brand = {};
            product.brand.name = (product.product_name.split(' ', 2)).join(' ').toString();
            product.name = brand_array.slice(2).join(' ').toString();
            break;
          case 'Pretty':
            product.name = product.product_name;
            break;
          default:
            product.brand = {};
            product.brand.name = brand_first;
            product.name = brand_array.slice(1).join(' ').toString();
        }
        delete product.product_name;
        product.active = parseInt(product.product_active);
        delete product.product_active;
        product.uid = parseInt(product.product_id);
        delete product.product_id;
        product.price = {};
        product.price.retail = parseFloat(product.product_price);
        delete product.product_price;
        product.date_updated = product.last_updated;
        delete product.last_updated;
        delete product.product_sku;
        _results.push(products.set(product, function(callback) {}));
      }
      return _results;
    }, this));
    services = new Services;
    impServices = new Import;
    impServices.services(__bind(function(json) {
      var key, service, value, _i, _len, _ref, _results;
      _ref = json.services;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        service = _ref[_i];
        for (key in service) {
          value = service[key];
          if (value === null || value === '') {
            delete service[key];
          }
        }
        service.name = service.service_name;
        delete service.service_name;
        service.active = parseInt(service.service_active);
        delete service.service_active;
        service.uid = parseInt(service.service_id);
        delete service.service_id;
        delete service.service_sku;
        _results.push(services.set(service, function(callback) {}));
      }
      return _results;
    }, this));
    appointments = new Appointments;
    impAppointments = new Import;
    impTransactions = new Import;
    impTransactionEntries = new Import;
    return impTransactions.transactions(__bind(function(transactionjson) {
      return impTransactionEntries.transactionEntries(__bind(function(entriesjson) {
        /* Transactions in phpcode = Appointments in nodecode 
            -Appointments in php = Transactions in node
            -Transaction_entries in php = Transactions in node  (sometimes tied together) */        var appointment, entry, _i, _j, _len, _len2, _ref, _ref2;
        _ref = transactionjson.transactions;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          appointment = _ref[_i];
          appointment.uid = parseInt(appointment.transaction_id);
          delete appointment.transaction_id;
          appointment.total = parseFloat(appointment.transaction_total);
          delete appointment.transaction_total;
          if (parseInt(appointment.transaction_void !== 0)) {
            appointment["void"] = {};
            appointment["void"]["void"] = true;
            if (appointment.transaction_void_by_uid) {
              appointment["void"].user = parseInt(appointment.transaction_void_by_uid);
            }
            if (appointment.transaction_void_date) {
              appointment["void"].date = appointmnet.transaction_void_date;
            }
          }
          appointment.confirmed = Boolean(parseInt(appointment.transaction_finalized));
          delete appointment.transaction_finalized;
          appointment.payments = [];
          if (appointment.transaction_payment_type !== null || appointment.transaction_payment_type !== '') {
            appointment.payments.push({
              type: appointment.transaction_payment_type,
              amount: appointment.total
            });
          }
          appointment.transactions = [];
          _ref2 = entriesjson.entries;
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            entry = _ref2[_j];
            if (appointment.uid === parseInt(entry.transaction_id)) {
              entry.uid = parseInt(entry.transaction_entry_id);
              delete entry.transaction_entry_id;
              entry.client = parseInt(appointment.transaction_uid);
              entry.stylist = parseInt(entry.transaction_entry_uid);
              delete entry.transaction_entry_uid;
              switch (entry.transaction_entry_type) {
                case 'service':
                  entry.service = {};
                  entry.service.id = entry.transaction_entry_service_id;
                  entry.service.price = parseFloat(entry.transaction_entry_price_added);
                  break;
                case 'product':
                  entry.product = {};
                  entry.product.id = entry.transaction_entry_service_id;
                  entry.product.quantity = entry.transaction_entry_quantity;
                  entry.product.price = parseFloat(entry.transaction_entry_price_added);
              }
              delete entry.transaction_entry_quantity;
              delete entry.transaction_entry_price_added;
              delete entry.transaction_entry_service_id;
              delete entry.transaction_entry_type;
              entry.date = {};
              entry.date.start = entry.transaction_entry_date_added;
              entry.date.updated = entry.transaction_entry_date_added;
              delete entry.transaction_entry_date_added;
              delete entry.transaction_id;
              appointment.transactions.push(entry);
            }
          }
          delete appointment.transaction_code;
          delete appointment.transaction_paid;
          delete appointment.transaction_payment_type;
          delete appointment.transaction_author_uid;
          delete appointment.transaction_updated_uid;
          delete appointment.transaction_stylists;
          delete appointment.transaction_products;
          delete appointment.transaction_client_name;
          delete appointment.transaction_void_date;
          delete appointment.transaction_void_by_uid;
          delete appointment.transaction_void;
          delete appointment.transaction_uid;
          delete appointment.transaction_created_date;
          delete appointment.transactoin_updated_date;
          appointments.set(appointment, function(callback) {});
        }
        return res.send('Done!');
      }, this));
    }, this));
  };
}).call(this);
