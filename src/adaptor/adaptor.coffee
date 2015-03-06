glob = require 'glob'
http = require 'http-request'
path = require 'path'
lightsaber = require 'lightsaber'
fs = require 'fs'

Nodesphere = require '../core/nodesphere'
Node = require '../core/node'
GoogleSpreadsheet = require "./google_spreadsheet"
Log = require "./log"

{ lodash_snake_case, log, p, pjson } = lightsaber
{ last, starts_with } = lodash_snake_case

class Adaptor

  constructor: (@config) ->
    @targets = []
    if @config.target is 'log'
      @targets.push new Log @config
    else throw "Unknown config.target: #{config.target}"
#    else if @config.target is 'gsheet'
#      @targets.push new GoogleSpreadsheet @config
#    else if @config.target is 'cayley'
#      @targets.push new Cayley @config
#    else if @config.target is 'file'
#      process.chdir 'nodes'

  @get_sync: (path) ->
    json = fs.readFileSync path, encoding: 'utf8'
    Nodesphere.digest JSON.parse json

  process: ->
    @get(@put)

  get: (put_callback) ->
    if @config.source_dir?
      nodesphere = new Nodesphere()
      files = glob.sync path.join(@config.source_dir, "*"), {}
      for file in files
        content = fs.readFileSync file, encoding: 'utf8'
        relative_dir = file.replace /// ^#{@config.source_dir}/? ///, ''
        terms = relative_dir.split '/'
        name = last terms
        node = new Node()
        node.meta 'source', file
        node.meta Node.KEY, name
#        for term in terms
#          node.meta 'tag', term
        words = content.match /[A-Za-z]+/g
        for word in words
          node.increment word
        nodesphere.add_node node
      put_callback nodesphere
    else if @config.source_gsheet?
      gsheet = new GoogleSpreadsheet @config
      gsheet.as_sphere put_callback
    else if @config.source_json?
      http.get @config.source_json, (error, response) =>
        if error
          throw "Error getting '#{@config.source_json}': #{error}"
        else if not starts_with response.headers?['content-type'], 'application/json'
          throw "The expected JSON is not available at:\n#{@config.source_json}"
        else
          json = response.buffer.toString()
          nodesphere = Nodesphere.digest JSON.parse json
          put_callback nodesphere
    else throw "No known source #{@config.source}"

  put: (nodesphere) =>
    output = if @config.weights then nodesphere.weight_sphere() else nodesphere
    for target in @targets
      target.put output

  @sphere_json: (source_url, callback) ->
    if GoogleSpreadsheet.understands source_url
      gsheet = new GoogleSpreadsheet url: source_url, gsheet_orientation: 'rows'
      gsheet.as_sphere (nodesphere) ->
        callback nodesphere.to_json()
    else
      console.error "No known adaptor for the content retrieved from #{source_url}"
      # http.get source_url, (source_error, source_response) ->
      #   if source_error
      #     console.error source_error
      #   else
      #     # content = source_response.buffer.toString()
      #     # if RevealDeck.understands content
      #     #   reveal_deck = new RevealDeck
      #     #     content: content
      #     #     url: source_url
      #     #   nodesphere = reveal_deck.as_sphere()
      #     #   callback nodesphere.to_json()
      #     # else 

module.exports = Adaptor
