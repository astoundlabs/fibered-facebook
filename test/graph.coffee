sinon = require 'sinon'
Graph = require '../lib/graph'

beforeEach ->
  @sandbox = sinon.sandbox.create()
  
afterEach ->
  @sandbox.restore()

describe 'Graph', ->

  describe 'without token', ->
    it 'should throw an error', ->
      (-> new Graph()).should.throw('Facebook token required')

  describe 'get', ->

    beforeEach ->
      @result = -> ''
      @httpStub =
        request: =>
          {body: @result()}
        
      @graph = new Graph 'foo', {http: @httpStub}
      
    describe 'returning bad json', ->
      it 'should throw an error', ->
        @result = (=> 'this is invalid json')
        (=> @graph.get('foo')).should.throw(/unable to parse/i)
        
      
    describe 'returning a graph error', ->
      it 'should throw an error', ->
        @result = (=> JSON.stringify(error: {message: 'a graph error'}))
        (=> @graph.get('foo')).should.throw(/a graph error/)
      
    describe 'with a triggered timeout', ->

      it 'should pass timeout to request', ->
        @requestStub = @sandbox.mock(@httpStub).expects('request').withArgs(sinon.match.has('timeout')).returns(body: '{}')
        @graph.get('foo', {timeout: 1000})
        @requestStub.verify()
      
    describe 'with a successful fetch', ->
      it 'should return parsed json', ->
        @json = {data: {id: 10, first_name: 'foo'}}
        @result = (=> JSON.stringify(@json))
        @graph.get('foo').should.eql @json