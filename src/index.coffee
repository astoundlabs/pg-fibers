pg = require 'pg'
Future = require 'fibers/future'
Connection = require './connection'
    
exports.connect = (params) ->

  # Synchronous (via fibers) connection
  f = new Future
  pg.connect(params, f.resolver())
  conn = f.wait()

  new Connection(conn)