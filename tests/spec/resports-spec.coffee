### Reports Tests ###
basedir = '../../'
App = require basedir + 'app.js'

# Controllers
require (basedir + 'reports').Reports

describe 'Daily Sales Report', ->
  it 'Accepts a date'