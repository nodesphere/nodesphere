{pjson, d} = require 'lightsaber/lib/log'
{ omit } = require 'lodash'

Node = require './node'
Edge = require './edge'
Identified = require './identified'

class Sphere extends Identified

  DEFAULT_KEY_LENGTH: 44

  constructor: (args) ->
    @setKey args
    @nodes = {}
    @edges = {}

  id: -> @_id

  attr: (predicate, object) ->
    @triple @id(), predicate, object

  triple: (subject, predicate, object) ->
    @addEdge
      start: @addNode name: subject
      end: @addNode name: object
      data:
        name: predicate

  addRootNode: (attrs) ->
    @rootNode = addNode attrs
    @rootNode

  addNode: (attrs) ->
    node = new Node(attrs, {@keyLength})
    @nodes[node.id()] = node
    node

  addEdge: (attrs) ->
    edge = new Edge attrs
    @edges[edge.id()] = edge
    edge

  getNode: (id) -> @nodes[id]

  # override this, eg for an adaptor sphere,
  # which gets its data async
  load: -> Promise.resolve @

  # for pretty printed JSON:
  # toJson(space: 4)
  #
  toJson: (args = {}) ->
    {replacer, space} = args
    JSON.stringify @data(), replacer, space

  data: ->
    {
      id: @id()
      nodes: @nodesData()
      edges: @edgesData()
    }

  nodesData: ->
    nodesData = {}
    for key, node of @nodes
      nodesData[key] = omit node.data(), 'id'
    nodesData

  edgesData: ->
    edgesData = {}
    for key, edge of @edges
      edgesData[key] = edge.data()
    edgesData

module.exports = Sphere
