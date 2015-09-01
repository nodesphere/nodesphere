{ json, log, p, pjson } = require 'lightsaber'
{ find, isEmpty, unique, values } = require 'lodash'
Promise = require 'bluebird'
ipfsAPI = require 'ipfs-api'

Node = require '../core/node'
Edge = require '../core/edge'

class IPFS
  constructor: (args)->
    {host, port} = args if args?
    @ipfs = Promise.promisifyAll if host? and port?
      ipfsAPI host, port
    else
      ipfsAPI()  # Note: host and port are autoconfigured if run from browser

  fetch: ({rootNodeId}) ->
    @ipfs.lsAsync rootNodeId
    .then (res) =>
      data = res.Objects[0]  # TODO handle multiple objects
      for node in data
        console.log node.Hash
        console.log 'Links [%d]', node.Links.length
        node.Links.forEach (link, i) ->
          console.log '[%d]', i, link
      @process {rootNodeId, data}
    .catch (err) ->
      console.error err

  process: ({rootNodeId, data}) =>
    start = new Node id: rootNodeId
    nodes = [start]
    edges = []
    for link in data.Links
      end = new Node
        id: link.Hash
        name: link.Name
        size: link.Size
        ipfsType: link.Type
      nodes.push end
      edges.push new Edge { start, end }
    {nodes, edges}

  path: (id) ->
    "/ipfs/#{id}"

module.exports = IPFS
