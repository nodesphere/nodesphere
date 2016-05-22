{ json, log, d, pjson } = require 'lightsaber/lib/log'
{ defaults, values } = require 'lodash'
Promise = require 'bluebird'
request = require 'axios'

Sphere = require '../core/sphere'

# This adaptor understands JSON in the native Nodesphere format, eg:
# https://github.com/core-network/client/blob/fadf9d00d5c9817672ee4c80fede178d733fcf1b/examples/dreams/dreams2.json

class NodesphereAdaptor
  @create: (args) ->
    Promise.resolve new NodesphereAdaptor args

  fetch: (args) ->
    {url} = args
    request {url}
      .then @process
      .catch (error) -> throw error

  process: ({data}) =>
    sphere = new Sphere
    for id, node of data.nodes
      defaults node, {id}
      sphere.addNode node
    for id, edge of data.edges
      edgeData =
        start: sphere.nodes[edge.start.id] ? throw new Error "Node with id #{edge.start.id} not found in nodesphere"
        end:   sphere.nodes[edge.end.id]   ? throw new Error "Node with id #{edge.end.id  } not found in nodesphere"
      edgeData.data = edge.data if edge.data
      sphere.addEdge edgeData
    sphere

module.exports = NodesphereAdaptor
