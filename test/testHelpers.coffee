{ d, json, pjson } = require 'lightsaber'
{ expect } = require 'chai'
{ isEqual, some, values } = require 'lodash'

class TestHelpers
  @assertEdge: (sphere, {subject, predicate, object}) ->
    edges = sphere.edgesData()
    found = some edges, (edge) ->
      edge.start.name is subject and
        isEqual(edge.data, predicate) and
        edge.end.name is object
    expect(found).to.eq true, "Edge [ #{subject} -[#{json predicate}]-> #{object} ] not found in #{pjson edges}"

module.exports = TestHelpers
