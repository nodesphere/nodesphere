{ d } = require 'lightsaber'
{ size } = require 'lodash'
{ should } = require 'chai'

Sphere = require '../../src/core/sphere'
multiply = require '../../src/algebra/multiply'

should()  # make should available on everything

describe 'multiply', ->

  it 'should create an analysis nodesphere', ->
    contentSphere = new Sphere
      edges: [
        {start: 'time poem',   end: 'the',       data: weight: 25}
        {start: 'time poem',   end: 'time',      data: weight: 3}
        {start: 'time poem',   end: 'is',        data: weight: 31}
        {start: 'beauty poem', end: 'beautiful', data: weight: 2}
        {start: 'beauty poem', end: 'clocks',    data: weight: 1}
      ]

    filterSphere = new Sphere
      edges: [
        {start: 'saturn', end: 'time',      data: weight: 1}
        {start: 'saturn', end: 'clocks',    data: weight: .25}
        {start: 'venus',  end: 'beautiful', data: weight: 1}
        {start: 'venus',  end: 'vanity',    data: weight: .25}
      ]

    resultSphere = multiply contentSphere, filterSphere
    edges = resultSphere.edges
    edges["time poem -> saturn"].get('weight').should.equal 3
    edges["beauty poem -> venus"].get('weight').should.equal 2
    edges["beauty poem -> saturn"].get('weight').should.equal .25
    size(edges).should.equal size(contentSphere.edges) + 3
