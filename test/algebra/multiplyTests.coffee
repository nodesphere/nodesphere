{ d, json, pjson } = require 'lightsaber'
{ size } = require 'lodash'
{ expect } = require 'chai'

{ assertEdge } = require '../testHelpers'

Sphere = require '../../src/core/sphere'
multiply = require '../../src/algebra/multiply'

describe 'multiply', ->

  makeEdge = ({start, end, data}) ->
    start: {id: start, name: start}
    end:   {id: end,   name: end}
    data:  data

  it 'should create an analysis nodesphere', ->
    contentSphere = new Sphere
      edges: [
        makeEdge start: 'time poem',   end: 'the',       data: weight: 25
        makeEdge start: 'time poem',   end: 'time',      data: weight: 3
        makeEdge start: 'time poem',   end: 'is',        data: weight: 31
        makeEdge start: 'beauty poem', end: 'beautiful', data: weight: 2
        makeEdge start: 'beauty poem', end: 'clocks',    data: weight: 1
      ]

    filterSphere = new Sphere
      edges: [
        makeEdge start: 'saturn', end: 'time',      data: weight: 1
        makeEdge start: 'saturn', end: 'clocks',    data: weight: .25
        makeEdge start: 'venus',  end: 'beautiful', data: weight: 1
        makeEdge start: 'venus',  end: 'vanity',    data: weight: .25
      ]

    resultSphere = multiply contentSphere, filterSphere

    # check a sample: original edges are copied from content sphere
    assertEdge resultSphere,
      subject: 'time poem'
      predicate: {weight: 25}
      object: 'the'

    expect(size(resultSphere.edges)).to.equal size(contentSphere.edges) + 3, "expected result sphere to have 3 more edges than content sphere, but got: #{pjson resultSphere.edges}"

    assertEdge resultSphere,
      subject: 'time poem'
      predicate: {weight: 3}
      object: 'saturn'

    assertEdge resultSphere,
      subject: 'beauty poem'
      predicate: {weight: 2}
      object: 'venus'

    assertEdge resultSphere,
      subject: 'beauty poem'
      predicate: {weight: .25}
      object: 'saturn'
