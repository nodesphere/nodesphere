{ json, log, p, pjson } = require 'lightsaber/lib/log'
{ defaults } = _ = require 'lodash'

Element = require './element'

class Node extends Element

  constructor: (@attrs={}, args={}) ->
    @setKey @attrs

  id: -> @attrs.id or @_id

  name: -> @attrs.name

  get: (propertyName) -> _.get @attrs, propertyName

  set: (propertyName, propertyValue) -> @attrs[propertyName] = propertyValue

  data: -> defaults @attrs, id: @id()

module.exports = Node
