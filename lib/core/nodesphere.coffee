merge = require 'lodash.merge'
omit = require "lodash.omit"
reject = require 'lodash.reject'
values = require "lodash.values"
is_empty = require "lodash.isempty"

{ json, log, p, pjson } = require 'lightsaber/lib/log'
{ type } = require 'lightsaber/lib/type'

Node = require './node'

class Nodesphere

  @digest: (data={}) ->
    @Dragon.digest data

  constructor: () ->
    throw "expected 0 arguments, got #{pjson arguments}" if arguments.length isnt 0
    @_nodes = []
    @_meta = new Node name: 'meta'

  add_node: (node) ->
    @_nodes.push node

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

  add_dict: (dict) ->
    @add_node new Node dict

  add_node: (node=null) ->
    node = new Node() unless node?
    @_nodes.push node
    node

  # pretty printed json
  to_json: ->
    json @data(), null, 2

  nodes: ->
    @_nodes

  node_data: (options = {}) ->
    for node in @_nodes
      if options.omit_keys
        omit node.data(), (value, key) ->
          key is options.omit_keys or key in options.omit_keys
      else
        node.data()

  data: ->
    for node in @_nodes
      @_meta.add_data_unless_exists 'node', node.id()
    data = [@_meta.data()]

    for node in @_nodes
      data.push node.data()
    data

class Nodesphere.Dragon

  @digest: (data) ->
    dragon = new Nodesphere.Dragon data
    dragon.sphere

  constructor: (data) ->
    @sphere = new Nodesphere()
    if type(data) is 'array'
      for item in data
        @digest_tree item
    else if type(data) is 'object'
      for own key, value of data
        @digest_tree value, parent_key: key
    else
      @digest_tree data

  digest_tree: (data, options={}) ->
    node = new Node()
    if type(data) is 'array'
      for item in data
        value = @node_id_or_literal item
        node.add_data '', value
    else if type(data) is 'object'
      node.add_key options.parent_key if options.parent_key?
      for own key, value of data
        if type(value) is 'array'
          for item in value
            attr_value = @node_id_or_literal item, parent_key: key
            node.add_data key, attr_value
        else
          attr_value = @node_id_or_literal value, parent_key: key
          node.add_data key, attr_value
    else
      throw "Unexpected type '#{type(data)}' -- '#{pjson data}'"
    @sphere.add_node node
    node

  node_id_or_literal: (data, options={}) ->
    if type(data) in ['string', 'number', 'boolean']
      data
    else if type(data) in ['null', 'undefined']
      null
    else if type(data) in ['array', 'object']
      node = @digest_tree data, options
      node.id()
    else
      throw type(data)

module.exports = Nodesphere

