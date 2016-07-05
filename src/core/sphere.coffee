{ pjson, d } = require 'lightsaber/lib/log'
{ type } = require 'lightsaber/lib/type'
{ cloneDeep, omit, sortBy } = _ = require 'lodash'

Node = require './node'
Edge = require './edge'
Element = require './element'

class Sphere extends Element

  @copy: (sphere) ->
    newSphere = new Sphere
    for __, node of sphere.nodes
      newSphere.addNode cloneDeep node.data()
    for __, edge of sphere.edges
      newSphere.addEdge cloneDeep edge.data()
    newSphere

  constructor: (args = {}) ->
    @setKey args
    @nodes = {}
    @edges = {}
    if args.nodes then @addNodes args.nodes
    if args.edges then @addEdges args.edges

  id: -> @_id

  attr: (predicate, object) ->
    @triple @id(), predicate, object

  triple: (subject, predicate, object) ->
    @addEdge
      start: @addNode name: subject
      end: @addNode name: object
      data:
        name: predicate

  addNodes: (nodes) ->
    @addNode(node) for node in nodes

  addRootNode: (data) ->
    @rootNode = @addNode data
    @rootNode

  addNode: (data) ->
    node = if data instanceof Node
      data
    else if type(data) is 'string'
      nodeId = data
      if @nodes[nodeId]
        @nodes[nodeId]
      else
        new Node({name: nodeId}, {@keyLength})
    else
      new Node(data, {@keyLength})
    @nodes[node.id()] = node
    node

  addEdges: (edges) ->
    @addEdge(edge) for edge in edges

  addEdge: (params) ->
    edge = if params instanceof Edge
      params
    else
      { start, end, data } = params
      new Edge
        start: @addNode start
        end: @addNode end
        data: data
    @edges[edge.id()] = edge
    edge

  getNode: (id) -> @nodes[id]

  # override this, eg for an adaptor sphere,
  # which gets its data async
  load: -> Promise.resolve @

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

  filterResults: (index) ->
    filterNode = @filterNode index
    nodeIds = []
    for edgeId, edge of @edges
      if edge.start.id() is filterNode.id()
        nodeIds.push edge.end.id()
    nodeIds

  filterNode: (index) -> @filterNodes()[index]

  filterNodes: ->
    filterNodes = _.filter(@nodes, (node) -> node.get('type') is 'filter')
    sortBy filterNodes, (filterNode) -> filterNode.get('rank')

module.exports = Sphere
