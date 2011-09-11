# Note: For now we crammed all the report stuff in here, will break it out as patterns emerge
$ ->

  ### Report Model for Backbone.js ###

  # Uses:
  #   -Daily sales report
  #   -Calculate quarterly sales tax
  #   -Stylist performance reports, etc.
  window.dailyReport = Backbone.Model.extend 
    initialize: (report) ->
      @set report
      
  # Reports collection - do we need this? :x
  window.Reports = Backbone.Collection.extend
    model: dailyReport
    # url: '/api/reports/salesTax/09-01-2011'

  # Initialize our reports collection
  window.reports = new Reports
  
  # reports.fetch()
  
  # Controller - this is where we define our routes
  window.Router = Backbone.Router.extend
    routes:
      '!/daily/:startDate': 'dailyReport'
  
    dailyReport: (startDate, endDate)->
      reports.url = '/api/reports/daily/' + startDate
      reports.fetch()
      console.log 'test! ' + startDate

  window.router = new Router
  
  Backbone.history.start()
  
  
  ###
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

  window.App = new AppView ###