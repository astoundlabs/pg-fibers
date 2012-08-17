require 'js-yaml'
settings = require('../config/database.yml').test
Future = require 'fibers/future'
child_process = require 'child_process'
pgfibers = require '../lib'
assert = should = require 'should'
Connection = require '../lib/connection'

exec = (cmd) ->
  f = new Future
  child_process.exec cmd, (err, stdout, stderr) ->
    if err
      f.throw(err)
    else
      f.return([stdout, stderr])
  f.wait()


before ->
  try
    exec("PGPASSWORD=#{settings.password} dropdb -U #{settings.user} #{settings.database}")
  catch e
    #pass
         
  exec("PGPASSWORD=#{settings.password} createdb -U #{settings.user} -O #{settings.user} #{settings.database}")  

describe 'pg-fibers', ->

  describe 'connection', ->
    beforeEach ->
      @conn = pgfibers.connect(settings)

    it 'should return a connection object', ->
      @conn.should.instanceof Connection
      
    it 'should define a query method', ->
      assert = @conn.query?
      
    describe 'query', ->
      it 'should return results immediately', ->
        @conn.query "create table foo(id serial primary key, name text)"
        @conn.query "insert into foo(name) values('bar')"
        @conn.query("select name from foo").rows[0].name.should.eql 'bar'
        @conn.query "drop table foo"

    describe 'end', ->
      beforeEach ->
        @conn.end()
        
      afterEach ->
        @conn = pgfibers.connect(settings)
        
      it 'should throw an error if query is issued', ->
        (->
          @conn.query("create table bar(id serial primary key)")
        ).should.throw()