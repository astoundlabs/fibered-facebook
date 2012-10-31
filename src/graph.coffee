module.exports = class Graph

  constructor: (@token, options = {}) ->
    throw new Error("Facebook token required") unless @token?
    @http = options.http || require 'fibered-http'
  
  get: (path, options = {}) ->

    query = options.query || {}
    query.access_token = @token

    res = @http.request {protocol: 'https', hostname: 'graph.facebook.com', path: @path, query: query, timeout: options.timeout}
    json = null
    try
      json = JSON.parse(res.body)
    catch e
      throw new Error("Unable to parse result of facebook graph call - #{e.toString()}")

    if json.error
      throw new Error("Facebook Graph Error: #{json.error.message}")

    json
    