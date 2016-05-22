{ json, log, p, pjson } = require 'lightsaber/lib/log'
{ defaults } = _ = require 'lodash'

Identified = require './identified'

class Node extends Identified

  constructor: (@_data={}, args={}) ->
    @setKey args

  id: -> @_data.id or @_id

  name: -> @_data.name

  get: (propertyName) -> _.get @_data, propertyName

  set: (propertyName, propertyValue) -> @_data[propertyName] = propertyValue

  data: -> defaults @_data, id: @id()

module.exports = Node
