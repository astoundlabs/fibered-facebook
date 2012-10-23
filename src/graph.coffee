https = require 'fibered-http'

class @exports.Graph

  constructor: (@token) ->
  
  get: (path, options = {}) ->

    query = options.query || {}
    query.access_token = @token

    res = https.request {protocol: 'https', hostname: 'graph.facebook.com', path: @path, query: query, timeout: options.timeout}

    json = null
    try
      json = JSON.parse(res.body)
    catch e
      throw new Error("Unable to parse result of facebook graph call - #{e.toString()}")

    if json.error
      throw new Error("Facebook Graph Error: #{json.error.message}")

    json  

  # Quick get does multiple gets in parellel with different offsets and limits to speed
  # up fetch times at the expense of more api queries and redundant bandwidth.  Only works
  # with graph calls that return an array of results in data field and has a paging.next field
  #
  # options
  #
  # perPage - Results per page
  # pages - Total pages to fetch.  If absent or null, will continue fetching pages until no more remain
  # concurrency - Number of pages to fetch concurrently
  
  quickGet: (path, options = {}) ->

    defaults =
      perPage: 50
      concurrency: 5

    options = _.extend({}, defaults, options)

    page = 0
    crawl = not options.pages
    state = {finished: [], pending: [0..pages]}

    for i in [0...options.concurrency]
      do (i) ->
        Fiber =>
          json = @get(path, _.extend({}, options, {offset: i * options.perPage, limit: options.perPage})) 

  redundantGet: ->