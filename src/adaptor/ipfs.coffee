{ json, log, d, pjson } = require 'lightsaber/lib/log'
{ find, isEmpty, unique, values } = require 'lodash'
Promise = require 'bluebird'
ipfsApi = require 'ipfs-api'

Sphere = require '../../lib/core/sphere'

class IpfsAdaptor
  @create: (options = {}) ->
    {host, port} = options
    delete options.host
    delete options.port
    host ?= process?.env?.IPFS_API_HOST ? 'localhost'
    port ?= process?.env?.IPFS_API_PORT ? '5001'
    ipfs = ipfsApi host, port, options
    ipfs.commands()  # hello IPFS server, all good?
    .then => new IpfsAdaptor {ipfs}

  constructor: ({@ipfs}) ->
    # unless @ipfs instanceof ipfsApi
    #   throw new Error "@ipfs is not instanceof ipfsAPI --
    #     try calling .create(...) if you called the constructor directly"

  put: ({content}) ->
    buffer = new @ipfs.Buffer content
    @ipfs.add buffer
    .then (items) =>
      for item in items
        item.hash
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
    sphere = new Sphere
    start = sphere.addNode id: rootNodeId
    for link in data.Links
      end = sphere.addNode
        id: link.Hash
        name: link.Name
        size: link.Size
        ipfsType: link.Type
      sphere.addEdge { start, end }
    sphere

  path: (id) ->
    "/ipfs/#{id}"

module.exports = IpfsAdaptor
