http = require 'http'

exports.Import = class Import
  constructor: ->
    @options = {
      host: 'bloom.getmochi.com'
      port: 80
      method: 'GET'
    }
  
  users: (callback) ->
    @options.path = 'http://bloom.getmochi.com/api/users/?secret=jsu90132jnkanclkm12k3mr12km5kmasDJFKASJFKJIJ51sadcmakj&format=json&action=list&num=10000'
    @getRequest callback
  
  userOptions: (callback) ->
    @options.path = "http://bloom.getmochi.com/api/users_options/?secret=jsu90132jnkanclkm12k3mr12km5kmasDJFKASJFKJIJ51sadcmakj&format=json&action=list&num=10000"
    @getRequest callback
  
  products: (callback) ->
    @options.path = "http://bloom.getmochi.com/api/products/?action=list&format=JSON&secret=jsu90132jnkanclkm12k3mr12km5kmasDJFKASJFKJIJ51sadcmakj&num=2000"
    @getRequest callback
    
  ### API: 'GET' ###
  getRequest: (callback) ->
    _options = @options

    tmp = []  # Russ at the NYC NodeJS Meetup said array push is faster

    http.request _options, (res) ->
      res.setEncoding 'utf8'

      res.on 'data', (chunk) ->
        tmp.push chunk  # Throw the chunk into the array

      res.on 'end', (e) ->
        body = tmp.join('')
        callback JSON.parse body
    .end()