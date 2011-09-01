http = require 'http'

exports.Import = class Import
  constructor: ->
    @options = {
      host: 'bloom.getmochi.com'
      port: 80
      path: 'http://bloom.getmochi.com/api/users/?secret=jsu90132jnkanclkm12k3mr12km5kmasDJFKASJFKJIJ51sadcmakj&format=json'
      method: 'GET'
    }
  
  users: (callback) ->
    @options.path += '&action=list&num=20'
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