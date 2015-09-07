{ json, log, p, pjson } = require 'lightsaber'
{ find, isEmpty, unique, values } = require 'lodash'
Promise = require 'bluebird'
ipfsApi = require 'ipfs-api'

Node = require '../core/node'
Edge = require '../core/edge'

class ipfsAdaptor
  @create: (args = {}) ->
    {host, port} = args
    host ?= process?.env?.IPFS_HOST
    port ?= process?.env?.IPFS_PORT
    if !window? and !host?
      return Promise.reject "host must be defined when running outside of a browser"
    ipfs = Promise.promisifyAll ipfsApi host, port
    ipfs.commandsAsync()
      .then => return new ipfsAdaptor {ipfs}

  constructor: ({@ipfs}) ->
    unless @ipfs instanceof ipfsApi
      throw new error "@ipfs is not instanceof ipfsAPI -- try calling .create(...) if you called the constructor directly"

  put: ({content}) ->
    @ipfs.addAsync new @ipfs.Buffer content
      .then (items) =>
        for item in items
          item.Hash
      .catch (err) ->
        console.error err

  fetch: ({rootNodeId}) ->
    @ipfs.lsAsync rootNodeId
    .then (response) =>
      data = response.Objects[0]  # TODO handle multiple objects
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

module.exports = ipfsAdaptor
