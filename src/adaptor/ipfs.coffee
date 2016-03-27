{ json, log, p, pjson } = require 'lightsaber'
{ find, isEmpty, unique, values } = require 'lodash'
Promise = require 'bluebird'
ipfsApi = require 'ipfs-api'

Node = require '../core/node'
Edge = require '../core/edge'

class IpfsAdaptor
  @create: (options = {}) ->
    {host, port} = options
    delete options.host
    delete options.port
    host ?= process?.env?.IPFS_HOST
    port ?= process?.env?.IPFS_PORT
    if !window? and !host?
      return Promise.reject "host must be defined when running outside of a browser"
    ipfs = ipfsApi host, port, options
    ipfs.commands()
      .then =>
        return new IpfsAdaptor {ipfs}

  constructor: ({@ipfs}) ->
    # unless @ipfs instanceof ipfsApi
    #   throw new Error "@ipfs is not instanceof ipfsAPI --
    #     try calling .create(...) if you called the constructor directly"

  put: ({content}) ->
    @ipfs.add new @ipfs.Buffer content
      .then (items) =>
        for item in items
          item.Hash
      .catch (err) ->
        console.error err

  fetch: ({rootNodeId}) ->
    @ipfs.ls rootNodeId
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
    {nodes, edges, rootNodeId}

  path: (id) ->
    "/ipfs/#{id}"

module.exports = IpfsAdaptor
