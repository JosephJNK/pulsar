http = require 'http'
should = require 'should'
Server = require '../'
{join} = require 'path'
{Client} = Server

randomPort = -> Math.floor(Math.random() * 1000) + 8000
port = randomPort()
serv = new Server http.createServer().listen port
getClient = -> new Client port: port, transports: ['websocket']

describe 'Pulsar', ->
  beforeEach ->
    serv.channels = {}
    serv.drop()

  describe 'channels', ->
    it 'should add', (done) ->
      channel = serv.channel 'test'
      should.exist channel
      done()

    it 'should call', (done) ->
      channel = serv.channel 'test'
      should.exist channel
      channel.on 'ping', (num) ->
        num.should.equal 2
        channel.emit 'pong', 2

      client = getClient()
      cchan = client.channel 'test'
      cchan.emit 'ping', 2
      cchan.on 'pong', (num) ->
        num.should.equal 2
        client.disconnect()
        done()