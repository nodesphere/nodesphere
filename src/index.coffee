module.exports =
  Node:     require './core/node'
  Edge:     require './core/edge'
  Sphere:   require './core/sphere'
  adaptors: require './adaptor'
  adaptor:  require './adaptor'  # don't break if using old style
