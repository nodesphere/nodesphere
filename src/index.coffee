adaptors =
  Ipfs: require './adaptor/ipfs'
  Json: require './adaptor/json'
  GoogleSpreadsheet: require './adaptor/googleSpreadsheet'
  Metamaps: require './adaptor/metamaps'

Nodesphere =
  Node: require './core/node'
  Edge: require './core/edge'
  Sphere: require './core/sphere'
  adaptors: adaptors
  adaptor: adaptors   # don't break if using old syntax

module.exports = Nodesphere
