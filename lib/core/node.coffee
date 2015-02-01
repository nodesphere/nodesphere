has = require "lodash.has"
omit = require "lodash.omit"
obj_values = require "lodash.values"
starts_with = require "lodash-node/compat/string/startsWith"  # pre-release
{ log, p, pjson } = require 'lightsaber/lib/log'
{ type } = require 'lightsaber/lib/type'

class Node

  @KEY = KEY = 'key'

  constructor: (dict={}, options={}) ->
    DEFAULT_OPTIONS =
      id_length: 0

    options = merge DEFAULT_OPTIONS, options

    @_data = {}
    @add_dict dict
    if options.id_length > 0
      @meta 'id', Node.random_key(options.id_length), skip_if_exists: 'key'

  meta: (key, value, options={}) ->
    @add_data @_meta_ize(key), value, options

  add_dict: (dict) ->
    if type(dict) isnt 'object'
      throw "Expected 'object', got unexpected type '#{type(dict)}' for '#{pjson dict}'"
    for own key, value of dict
      @add_data key, value

  add_data_unless_exists: (key, value) ->
    @add_data key, value, skip_if_exists: 'value'

  add_data: (key, value, options={}) ->
    return if options.skip_if_exists is 'key'   and @_has key
    return if options.skip_if_exists is 'value' and @_has key, value
    if type(value) is 'array'
      for item in value
        @_add_item key, item, options
    else
      @_add_item key, value, options

  _add_item: (key, value) ->
    throw "Expected key to be of type 'string', got: '#{type(key)}'" unless type(key) is 'string'
    @_data[key] ?= []
    if type(value) in ['boolean', 'number', 'string']
      @_data[key].push value
    else if type(value) in ['date']
      @_data[key].push value.toISOString()
    else if type(value) in ['regexp', 'function']
      @_data[key].push value.toString()
    else if type(value) in ['null', 'undefined']
      @_data[key].push null
    else
      throw "Unexpected value '#{value}' of type '#{type(value)}' for key '#{key}'"

  increment: (key, amount = 1) ->
    throw "Expected key to be of type 'string', got: '#{type(key)}'" unless type(key) is 'string'
    @_data[key] ?= [ 0 ]
    for value, index in @_data[key]
      throw "Expected value to be of type 'number', got: #{type(value)}:" unless type(value) is 'number'
      @_data[key][index] += amount

  label: ->
    @_get_key() ? id()

  id: ->
    @_data._id?[0]  # or throw "no _id property found for #{pjson @}"

  data: ->
    @_data


  # omit metadata: anything starting with underscore
  props: ->
    omit @_data, (value, key) -> starts_with key, '_'

  _get_key: ->
    @get_keys()?[0]

  get_keys: ->
    @_get_meta KEY

  add_key: (key) ->
    @add_keys key

  add_keys: (key) ->
    @meta KEY, key

  has_key: (key) ->
    @_has_meta KEY, key

  _get_meta: (key) ->
    @_data[@_meta_ize key]

  _has_meta: (search_key, search_value) ->
    @_has @_meta_ize(search_key), search_value

  _has: (search_key, search_value) ->
    if search_value?
      for own key, values of @_data
        for value in values
          if key is search_key and value is search_value
            return true
      return false
    else
      has @_data, search_key

  _meta_ize: (key) ->
    if starts_with key, '_' then key else "_#{key}"

  weights: ->
    weights = {}
    if @_numeric_values()
      for own key, values of @props()
        for value in values
          value = parseFloat value
          if not Number.isNaN value
            weights[key] ?= 0
          weights[key] += value
    else
      for own key, values of @_data
        weights[key] ?= 0             # keys are weighted = 0, values = 1
        for value in values
          weights[value] ?= 0
          weights[value] += 1
    weights

  _numeric_values: ->
    for values in obj_values(@props())
      for value in values
        if Number.isNaN parseFloat value
          return false
    return true

  @random_key = (key_length=88) ->
    alphabet = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ".split /// ///   # base 58 -- no 0, O, 1, or l chars
    chars = for i in [0...key_length]
      alphabet[Math.floor Math.random() * 58]
    chars.join ''

module.exports = Node
