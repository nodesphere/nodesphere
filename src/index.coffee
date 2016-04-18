adaptors =
  Ipfs: require './adaptor/ipfs'
  Json: require './adaptor/json'
  GoogleDrive: require './adaptor/googleDrive'
  GoogleSpreadsheet: require './adaptor/googleSpreadsheet'
  Metamaps: require './adaptor/metamaps'

Nodesphere =
  Node: require './core/node'
  Edge: require './core/edge'
  Sphere: require './core/sphere'
  adaptors: adaptors
  adaptor: adaptors   # don't break if using old style

module.exports = Nodesphere
