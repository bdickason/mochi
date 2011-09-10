(function() {
  /* Reports - Business metric reporting for the salon */  var Appointment, Product, Reports, Service, User, cfg;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  cfg = require('../config/config');
  Appointment = require('../models/appointment-model');
  Product = require('../models/product-model');
  Service = require('../models/service-model');
  User = require('../models/user-model');
  exports.Reports = Reports = (function() {
    function Reports() {}
    Reports.prototype.daily = function(startDate, endDate, callback) {
      startDate = new Date(startDate);
      startDate.setHours(0, 0, 0);
      endDate = new Date(startDate);
      endDate.setHours(23, 59, 59);
      this.report = {};
      this.report.dates = {};
      this.report.dates.start = startDate;
      this.report.dates.end = endDate;
      return Service.find({
        active: 1
      }, __bind(function(err, services) {
        return Product.find({
          active: 1
        }, __bind(function(err, products) {
          return Appointment.find({
            'transactions.date.start': {
              '$gte': startDate,
              '$lte': endDate
            },
            'confirmed': true
          }, __bind(function(err, data) {
            var appointment, found, newPayment, newProduct, newService, pay, payment, product, service, transaction, _i, _j, _k, _l, _len, _len2, _len3, _len4, _len5, _len6, _len7, _len8, _m, _n, _o, _p, _product, _ref, _ref2, _ref3, _ref4, _ref5, _service;
            this.report.totals = {};
            this.report.services = [];
            this.report.totals.services = 0;
            this.report.products = [];
            this.report.totals.products = 0;
            this.report.payments = [];
            this.report.totals.payments = 0;
            for (_i = 0, _len = data.length; _i < _len; _i++) {
              appointment = data[_i];
              _ref = appointment.transactions;
              for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
                transaction = _ref[_j];
                if (transaction.service.price) {
                  this.report.totals.services += transaction.service.price;
                  for (_k = 0, _len3 = services.length; _k < _len3; _k++) {
                    _service = services[_k];
                    if (parseInt(transaction.service.id) === parseInt(_service.uid)) {
                      transaction.service.name = _service.name;
                    }
                  }
                  found = false;
                  _ref2 = this.report.services;
                  for (_l = 0, _len4 = _ref2.length; _l < _len4; _l++) {
                    service = _ref2[_l];
                    if (parseInt(service.uid) === parseInt(transaction.service.id)) {
                      service.transactions.push(transaction.service.price);
                      found = true;
                    }
                  }
                  if (!found) {
                    newService = {};
                    newService.uid = transaction.service.id;
                    newService.name = transaction.service.name;
                    newService.transactions = [];
                    newService.transactions.push(transaction.service.price);
                    this.report.services.push(newService);
                  }
                }
                if (transaction.product.price) {
                  this.report.totals.products += transaction.product.price;
                  for (_m = 0, _len5 = products.length; _m < _len5; _m++) {
                    _product = products[_m];
                    if (parseInt(transaction.product.id) === parseInt(_product.uid)) {
                      transaction.product.name = _product.brand[0].name + ' ' + _product.name;
                    }
                  }
                  found = false;
                  _ref3 = this.report.products;
                  for (_n = 0, _len6 = _ref3.length; _n < _len6; _n++) {
                    product = _ref3[_n];
                    if (parseInt(product.uid) === parseInt(transaction.product.id)) {
                      product.transactions.push(transaction.product.price);
                      found = true;
                    }
                  }
                  if (!found) {
                    newProduct = {};
                    newProduct.uid = transaction.product.id;
                    newProduct.name = transaction.product.name;
                    newProduct.transactions = [];
                    newProduct.transactions.push(transaction.product.price);
                    this.report.products.push(newProduct);
                  }
                }
              }
              _ref4 = appointment.payments;
              for (_o = 0, _len7 = _ref4.length; _o < _len7; _o++) {
                payment = _ref4[_o];
                this.report.totals.payments += parseFloat(payment.amount);
                found = false;
                _ref5 = this.report.payments;
                for (_p = 0, _len8 = _ref5.length; _p < _len8; _p++) {
                  pay = _ref5[_p];
                  if (payment.type === pay.name) {
                    pay.amounts.push(payment.amount);
                    found = true;
                  }
                }
                if (!found) {
                  newPayment = {};
                  newPayment.uid = payment.uid;
                  newPayment.name = payment.type;
                  newPayment.amounts = [];
                  newPayment.amounts.push(payment.amount);
                  this.report.payments.push(newPayment);
                }
              }
            }
            this.report.tax = {};
            this.report.tax.services = Math.round(this.report.totals.services * cfg.SERVICE_TAX * 100) / 100;
            this.report.tax.products = Math.round(this.report.totals.products * cfg.PRODUCT_TAX * 100) / 100;
            this.report.totals.grand = this.report.totals.services + this.report.totals.products;
            return callback(this.report);
          }, this));
        }, this));
      }, this));
    };
    Reports.prototype.salesTax = function(startDate, endDate, callback) {
      startDate = new Date(startDate);
      startDate.setHours(0, 0, 0);
      endDate = new Date(endDate);
      endDate.setHours(23, 59, 59);
      this.report = {};
      this.report.dates = {};
      this.report.dates.start = startDate;
      this.report.dates.end = endDate;
      this.report.totals = {};
      this.report.totals.services = 0;
      this.report.totals.serviceTax;
      this.report.totals.products = 0;
      return Appointment.find({
        'transactions.date.start': {
          '$gte': startDate,
          '$lte': endDate
        },
        'confirmed': true
      }, __bind(function(err, data) {
        var appointment, transaction, _i, _j, _len, _len2, _ref;
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          appointment = data[_i];
          _ref = appointment.transactions;
          for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
            transaction = _ref[_j];
            console.log(transaction.date.start);
            if (transaction.service.price) {
              this.report.totals.services += transaction.service.price;
            }
            if (transaction.product.price) {
              this.report.totals.products += transaction.product.price;
            }
          }
        }
        this.report.totals.services = Math.round(this.report.totals.services * 100) / 100;
        this.report.totals.products = Math.round(this.report.totals.products * 100) / 100;
        this.report.tax = {};
        this.report.tax.services = Math.round(this.report.totals.services * cfg.SERVICE_TAX * 100) / 100;
        this.report.tax.products = Math.round(this.report.totals.products * cfg.PRODUCT_TAX * 100) / 100;
        return callback(this.report);
      }, this));
    };
    return Reports;
  })();
}).call(this);
