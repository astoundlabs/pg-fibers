Future = require 'fibers/future'

module.exports = class Connection
  constructor: (@connection) ->
    
  query: (args...) =>
    f = new Future
    args.push(f.resolver())
    @connection.query(args...)
    f.wait()

  end: =>
    @connection.end()