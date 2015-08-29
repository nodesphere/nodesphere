class Node

  constructor: (@data={}) ->
    throw new Error "Node 'id' not found in constructor args: #{json @data}" unless @data.id

  # data: -> @_data

  id: -> @data.id

  name: -> @data.name #or @data.id

module.exports = Node
