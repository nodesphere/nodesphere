require('chai').should()

{ log, p } = require 'lightsaber'

Nodesphere = require '../../lib/core/nodesphere'
multiply = require '../../lib/algebra/multiply'

describe 'multiply', ->

  it 'should create an analysis nodesphere', ->
    content_sphere = Nodesphere.digest [
      {
        "_key": [ "time poem" ]
        "the": [ 25 ]
        "time": [ 3 ]
        "is": [ 31 ]
      }
      {
        "_key": ["beauty poem"]
        "beautiful": [2]
        "clocks": [1]
      }
    ]

    filter_sphere = Nodesphere.digest [
      {
        "_key": [ "Saturn" ]
        "time": [ 1 ]
        "clocks": [ .25 ]
      }
      {
        "_key": [ "Venus" ]
        "beautiful": [ 1 ]
        "vanity": [ .25 ]
      }
    ]

    expected_data =
      [
        {
          "_key": ["time poem"]
          "Saturn": [ 3 ]
        }
        {
          "_key": ["beauty poem"]
          "Venus": [ 2 ]
          "Saturn": [ .25 ]
        }
      ]

    result_sphere = multiply [content_sphere, filter_sphere]
    result_sphere.node_data(omit_keys: '_id').should.deep.equal expected_data
