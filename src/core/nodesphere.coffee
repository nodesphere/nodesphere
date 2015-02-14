lightsaber = require 'lightsaber'
Node = require './node'

{ indent, json, lodash_snake_case, log, p, pjson, type } = lightsaber
{ merge, omit, reject, first, keys, size } = lodash_snake_case
obj_values = lodash_snake_case.values

class Nodesphere

  @digest: (data={}) ->
    @Dragon.digest data

  constructor: () ->
    throw "expected 0 arguments, got #{pjson arguments}" if arguments.length isnt 0
    @_nodes = []
    @_meta = new Node
    @_meta.add_key 'metadata'

  meta: (key, value) ->
    @_meta.add_data key, value

  add_data: (node_key, attribute, value) ->
    return unless node_key and attribute and value
    match = false
    for node in @_nodes
      if node.has_key node_key
        node.add_data attribute, value
        match = true
    if not match
      node = @add_node()
      node.add_key node_key
      node.add_data attribute, value

  add_dict: (dict) ->
    @add_node new Node dict

  add_node: (node=null) ->
    node = new Node() unless node?
    @_nodes.push node
    node

  # pretty printed json
  to_json: ->
    nodes_json = for node in @_all_updated_nodes()
      node.to_json()
    nodes_json = nodes_json.join(",\n")
    "[\n#{indent nodes_json}\n]\n"

  nodes: ->
    @_nodes

  node_data: (options = {}) ->
     for node in @_nodes
       node.data options

  data: ->
    for node in @_all_updated_nodes()
      node.data()

  weight_sphere: ->
    weight_sphere = new Nodesphere()
    for node in @_nodes
      weight_sphere.add_node node.weight_node()
    weight_sphere

  _all_updated_nodes: ->
    @_update_meta()
    @_all_nodes()

  _update_meta: ->
    for node in @_nodes
      @_meta.add_data_unless_exists 'node', node.label()

  # meta + nodes as a single array
  _all_nodes: ->
    nodes = [@_meta]
    for node in @_nodes
      nodes.push node
    nodes

class Nodesphere.Dragon

  @digest: (data) ->
    dragon = new Nodesphere.Dragon data
    dragon.sphere

  constructor: (data) ->
    @sphere = new Nodesphere()
    if type(data) is 'object'
      for own key, value of data
        @_digest_tree value, parent_key: key
    else if type(data) is 'array'
      if @_all_single_attribute_objects data
        @_digest_tree data
      else
        for item in data
          @_digest_tree item
    else
      @_digest_tree data

  _digest_tree: (data, options={}) ->
    node = new Node {}, id: true
    if type(data) is 'array'
      if @_all_single_attribute_objects data
        for item in data
          [key, value] = @_attribute item
          node.add_data key, @_node_id_or_literal(value)
      else
        for item in data
          value = @_node_id_or_literal item
          node.add_data '', value
    else if type(data) is 'object'
      node.add_key options.parent_key if options.parent_key?
      for own key, value of data
        if type(value) is 'array'
          for item in value
            attr_value = @_node_id_or_literal item, parent_key: key
            node.add_data key, attr_value
        else
          attr_value = @_node_id_or_literal value, parent_key: key
          node.add_data key, attr_value
    else
      throw "Unexpected type '#{type(data)}' -- '#{pjson data}'"
    @sphere.add_node node
    node

  _node_id_or_literal: (data, options={}) ->
    if type(data) in ['string', 'number', 'boolean']
      data
    else if type(data) in ['null', 'undefined']
      null
    else if type(data) in ['array', 'object']
      node = @_digest_tree data, options
      node.id() or throw("No node.id() for node: #{pjson node}")
    else
      throw type(data)

  _all_single_attribute_objects: (array) ->
    for object in array
      if not @_valid_attribute object
        return false
    return true

  _attribute: (object) ->
    @_validate_attribute(object)
    key = first keys object
    value = object[key]
    [key, value]

  _validate_attribute: (attribute) ->
    unless @_valid_attribute(attribute)
      throw "invalid attribute #{pjson attribute}"

  _valid_attribute: (attribute) ->
    type(attribute) is 'object' and size(attribute) is 1

module.exports = Nodesphere

