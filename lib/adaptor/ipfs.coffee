{ json, log, p, pjson } = require 'lightsaber'
{ find, isEmpty, unique, values } = require 'lodash'
Promise = require 'bluebird'
xhr = Promise.promisify require 'xhr'

Node = require '../core/node'
Edge = require '../core/edge'

class IPFS
  fetch: ({rootNodeId, recursive}) ->
    recursive ?= false
    API_REFS_FORMAT = encodeURIComponent '<src> <dst> <linkname>'
    params = {arg: rootNodeId, format: API_REFS_FORMAT, recursive}
    queryString = ("#{k}=#{v}" for k, v of params).join '&'
    uri = "/api/v0/refs?#{queryString}"
    xhr { uri }
      .then @process
      .catch (error) -> throw error

  process: ([res]) =>
    if res.statusCode isnt 200
      throw new Error res.rawRequest.response
    data = res.body
    tree = {}
    nodeMap = {}
    edges = []

    refApiPattern = /"Ref": "(\S+) (\S+) (\S+)\\n"/g
    while match = refApiPattern.exec data
      [whole, startId, endId, linkName] = match
      start = @cache nodeMap, id: startId
      end = @cache nodeMap, id: endId, name: linkName
      edges.push new Edge { start, end }

    nodes = values nodeMap
    {nodes, edges}

  cache: (nodeMap, props) ->
    id = props.id ? throw new Error
    name = props.name
    if node = nodeMap[id]
      if name
        node.names ?= [node.name]
        node.names.push name
        node.name = unique(nodeMap[id].names).join ' / '
    else
      node = new Node props
      nodeMap[id] = node
    node

  path: (id) ->
    "/ipfs/#{id}"

module.exports = IPFS
