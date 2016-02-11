module.exports =
  Node: require './core/node'
  Edge: require './core/edge'
  adaptor:
    Ipfs: require './adaptor/ipfs'
    Json: require './adaptor/json'
    GoogleSpreadsheet: require './adaptor/googleSpreadsheet'