pg = require 'pg'
Future = require 'fibers/future'
Connection = require './connection'
    
exports.connect = (params) ->

  # Synchronous (via fibers) connection
  conn = pg.connect(params, (f = new Future).resolver()) and f.wait()

  new Connection(conn)