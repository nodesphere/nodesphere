{ log, p, similar } = require 'lightsaber'
{ isFinite } = require 'lodash'

Node = require '../core/node'
Sphere = require '../core/sphere'

class Algebra
  @multiply: (contentSphere, filterSphere) ->
    product = Sphere.copy contentSphere
    for __, contentEdge of contentSphere.edges
      for __, filterEdge of filterSphere.edges
        if contentEdge.end.toJson().toLowerCase() is filterEdge.end.toJson().toLowerCase()
          if isFinite(contentEdge.get('weight')) and isFinite(filterEdge.get('weight'))
            product.addEdge
              start: contentEdge.start
              end: filterEdge.start
              data: weight: contentEdge.get('weight') * filterEdge.get('weight')
    product

module.exports = Algebra
