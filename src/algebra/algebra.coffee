{ json, log, d, similar } = require 'lightsaber'
{ isFinite } = require 'lodash'

Node = require '../core/node'
Sphere = require '../core/sphere'

class Algebra
  @multiply: (contentSphere, filterSphere) ->
    product = Sphere.copy contentSphere
    for __, contentEdge of contentSphere.edges
      for __, filterEdge of filterSphere.edges
        if contentEdge.end.toJson(omit: 'id').toLowerCase() is filterEdge.end.toJson(omit: 'id').toLowerCase()
          weight = if isFinite(contentEdge.get('weight')) and isFinite(filterEdge.get('weight'))
            contentEdge.get('weight') * filterEdge.get('weight')

          product.addEdge
            start: contentEdge.start
            end: filterEdge.start
            data: {weight}
    product

module.exports = Algebra
