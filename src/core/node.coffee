{ json, log, p, pjson } = require 'lightsaber/lib/log'
{ defaults } = _ = require 'lodash'

Element = require './element'

class Node extends Element

  constructor: (@attrs={}, @sphere) ->
    @setKey()

  id: -> @attrs.id or @_id

  name: -> @get 'name'

  get: (propertyName) -> _.get @attrs, propertyName

  set: (propertyName, propertyValue) -> @attrs[propertyName] = propertyValue

  data: -> defaults @attrs, id: @id()

  related: (predicateName) ->
    subject = @name()
    return unless subject
    @sphere.getRelatedNode(subject, predicateName)

module.exports = Node
