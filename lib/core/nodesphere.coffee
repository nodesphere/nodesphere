lightsaber  = require 'lightsaber'
{log, p, pretty, type, sha384} = lightsaber
{canonical_json} = require './lib/util'
_ = require 'lodash-node'

class NodeSphere

  rand_key = (key_length=88) ->
    alphabet = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ".split /// ///   # base 58 -- no 0, O, 1, or l chars
    chars = for i in [0...key_length]
      alphabet[Math.floor(Math.random()*alphabet.length)]
    "key-#{chars.join('')}"

  constructor: () ->
    @keys = [ rand_key 44 ]
    @edges = {}
    @nodes = {}

  key: ->
    @keys[0] or raise("No keys found")

  put_edge: (subject, predicate, object) ->
    json = canonical_json
      subject: @put_node subject
      predicate: @put_node predicate
      object: @put_node object
    hash = @hash json
    @edges[hash] = json
    hash

  put_node: (node) ->
    hash = @hash node
    @nodes[hash] = node
    hash

  hash: (data) ->
    sha384 data

  integrate: (sphere) ->
    @edges = _.merge @edges, sphere.edges
    @nodes = _.merge @nodes, sphere.nodes

  to_json: ->


module.exports = NodeSphere
