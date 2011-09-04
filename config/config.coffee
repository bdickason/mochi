### Config.coffee - Configuration of random stuffs ###

exports.SESSION_SECRET = process.env.SESSION_SECRET || 'internets'
exports.SESSION_ID = process.env.SESSION_ID || 'express.sid'

# Redis
exports.REDIS_HOSTNAME = process.env.REDIS_HOSTNAME || 'localhost'
exports.REDIS_PORT = process.env.REDIS_PORT || 6379
exports.REDIS_CACHE_TIME = process.env.REDIS_CACHE_TIME || 10000    #Time to cache objects (in seconds)

# Mongo
exports.MONGO_HOST = process.env.MONGO_HOST || 'localhost'
exports.MONGO_DB = process.env.MONGO_DB || 'mochi'

## DON'T TOUCH
exports.DB = 'mongodb://' + @MONGO_HOST + '/' + @MONGO_DB
exports.MONGOHQ_URL = process.env.MONGOHQ_URL || null
exports.REDISTOGO_URL = process.env.REDISTOGO_URL || null

# Fix for heroku
if exports.MONGOHQ_URL != null
  exports.DB = exports.MONGOHQ_URL
  