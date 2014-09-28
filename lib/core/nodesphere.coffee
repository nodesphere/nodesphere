_ = require 'lodash-node' 
lightsaber  = require 'lightsaber'

{
  canonical_json
  log
  p
  pjson
  pretty
  sha384
  type
} = lightsaber

class Nodesphere

  constructor: () ->
    @keys = [_rand_key()]
    @edges = {}
    @nodes = {}

  key: ->
    @keys[0] or raise("No keys found")

  put_edge: (subject, predicate, object) ->
    return unless subject and object  # required for an edge
    data = {}
    data.subject   = @put_node subject
    data.object    = @put_node object
    data.predicate = @put_node predicate if predicate
    hash = _hash data
    @edges[hash] = data
    hash

  put_node: (data) ->
    hash = _hash data
    @nodes[hash] = data
    hash

  # integrate: (sphere) ->
  #   @edges = _.merge @edges, sphere.edges
  #   @nodes = _.merge @nodes, sphere.nodes

  to_json: ->
    pjson _data  # pretty printed json

  _data: ->
    data =
      nodes: @nodes
      edges: @edges
    hash = _hash data
    @keys.push hash unless hash in @keys
    data.keys = @keys
    data

  _hash = (data) ->
    sha384 _canonicalize data

  _canonicalize = (data) ->
    if type(data) is 'string'
      data
    else
      canonical_json data

  _rand_key = (key_length=88) ->
    alphabet = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ".split /// ///   # base 58 -- no 0, O, 1, or l chars
    chars = for i in [0...key_length]
      alphabet[Math.floor(Math.random()*alphabet.length)]
    "key-#{chars.join('')}"

module.exports = Nodesphere
