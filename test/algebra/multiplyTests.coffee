{ d, pjson } = require 'lightsaber'
{ size } = require 'lodash'
{ should } = require 'chai'

Sphere = require '../../src/core/sphere'
multiply = require '../../src/algebra/multiply'

should()  # make should available on everything

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
    edges = resultSphere.edges
    edges["time poem -> the"].get('weight').should.equal 25  # sample: original edges copied from content sphere
    size(edges).should.equal size(contentSphere.edges) + 3, "expected result sphere to have only 3 more edges than content sphere, but got: #{pjson edges}"

    edges["time poem -> saturn"].get('weight').should.equal 3
    edges["beauty poem -> venus"].get('weight').should.equal 2
    edges["beauty poem -> saturn"].get('weight').should.equal .25
