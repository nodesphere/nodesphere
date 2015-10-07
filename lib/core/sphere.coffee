{json, p} = require 'lightsaber'

Node = require './node'
Edge = require './edge'

class Sphere

  constructor: (args) ->
    @id = args?.id or Node.randomKey()
    @nodes = {}
    @edges = {}

  attr: (predicate, object) ->
    @triple @id, predicate, object

  triple: (subject, predicate, object) ->
    @addEdge
      start: @addNode name: subject
      end: @addNode name: object
      data:
        name: predicate

  addNode: (attrs) ->
    node = new Node attrs
    @nodes[node.id()] = node

  addEdge: (attrs) ->
    edge = new Edge attrs
    @edges[edge.id()] = edge

module.exports = Sphere
