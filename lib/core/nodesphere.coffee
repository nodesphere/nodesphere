_ = require 'lodash-node'
lightsaber  = require 'lightsaber'

{log, p, sha384, canonical_json} = lightsaber

class NodeSphere

  rand_key = (key_length=88) ->
    alphabet = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ".split /// ///   # base 58 -- no 0, O, 1, or l chars
    chars = for i in [0...key_length]
      alphabet[Math.floor(Math.random()*alphabet.length)]
    "key-#{chars.join('')}"

  constructor: () ->
    @keys = [rand_key 44]
    @edges = {}
    @nodes = {}

  key: ->
    @keys[0] or raise("No keys found")

  put_edge: (subject, predicate, object) ->
    data =
      subject: @put_node subject
      predicate: @put_node predicate
      object: @put_node object
    hash = _hash canonical_json data
    @edges[hash] = data
    hash

  put_node: (node) ->
    data = { content: node }
    hash = _hash canonical_json data
    @nodes[hash] = data
    hash

  integrate: (sphere) ->
    @edges = _.merge @edges, sphere.edges
    @nodes = _.merge @nodes, sphere.nodes

  to_json: ->
    canonical_json
      nodes: @nodes
      edges: @edges

  _hash = (data) ->
    sha384 data

module.exports = NodeSphere
