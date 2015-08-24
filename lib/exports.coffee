module.exports =
  Node: require './core/node'
  Edge: require './core/edge'
  adaptor:
    Json: require './adaptor/json'
    Ipfs: require './adaptor/ipfs'
