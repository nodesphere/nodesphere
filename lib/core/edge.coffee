{json, p} = require 'lightsaber'

Node = require './node'

class Edge

  constructor: ({ @start, @end }) ->
    throw new Error "start must be of type Node, got #{json @start}" unless @start instanceof Node
    throw new Error "end must be of type Node, got #{json @end}" unless @end instanceof Node
    throw new Error "Missing start [ID: #{@start?.id}] and/or end [ID: #{@end?.id}] in 'args' " unless @start? and @end?

  id: -> "#{@start.id} -> #{@end.id}"

  # data: -> {@start, @end}

module.exports = Edge
