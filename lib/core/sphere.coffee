{json, p} = require 'lightsaber'

Node = require './node'
Edge = require './edge'

class Sphere

  constructor: (args) ->
    @id = args?.id or Node.randomKey()

  attr: (predicate, object) ->
    @triple @id, predicate, object

  triple: (subject, predicate, object) ->
    new Edge
      start: new Node name: subject
      end: new Node name: object
      data:
        name: predicate

module.exports = Sphere
