{ json, log, p, pjson } = require 'lightsaber'
{ defaults, values } = require 'lodash'
Promise = require 'bluebird'
xhr = Promise.promisify require 'xhr'

Node = require '../core/node'
Edge = require '../core/edge'

class JsonAdaptor
  fetch: ({sourceUri}) ->
    xhr { uri: sourceUri }
      .then @process
      .catch (error) -> throw error

  # currently expects data in the format:
  # {
  #   "nodes":[
  #     {"name":"Myriel","group":1}     // implicit ID 0
  #     {"name":"Napoleon","group":1}   // implicit ID 1
  #   ]
  #   "links":[
  #     {"source":1,"target":0,"value":1}
  #     {"source":2,"target":0,"value":8}
  #   ]
  # }
  process: ([res]) =>
    data = JSON.parse res.body
    nodeMap = {}
    edges = []
    edgesStartingWithNode = {}
    maxNodePopularity = 0
    for {source} in data.links
      edgesStartingWithNode[source] ?= 0
      edgesStartingWithNode[source] += 1
      if edgesStartingWithNode[source] > maxNodePopularity
        mostPopularNode = source
    for {source, target, value} in data.links
      if source is mostPopularNode
        edges.push new Edge
          start: @cache nodeMap, defaults data.nodes[source], id: source
          end: @cache nodeMap, defaults data.nodes[target], id: target
          value: value
    nodes = values nodeMap
    {nodes, edges, suggestedRootNodeId: mostPopularNode}

    # to get all nodes:
    # for nodeData, index in data.nodes
    #   nodeMap[index] = new Node defaults nodeData, id: index # .toString()

  cache: (nodeMap, props) ->
    id = props.id ? throw new Error
    nodeMap[id] ?= new Node props
    nodeMap[id]

module.exports = JsonAdaptor
