require('chai').should()
reject = require "lodash.reject"
{ log, p } = require 'lightsaber'

Nodesphere = require '../../lib/core/nodesphere'

describe 'Nodesphere.digest', ->

  it 'should add an array of hashes as expected', ->
    input =
      [
        {
          "type": "INTENTION"
          "description": "I'd like to create an Enlightened Singularity."
        }
        {
          "type": "REQUEST"
          "description": "I'm looking for Collaborators."
        }
      ]

    expected_data =
      [
        {
          "description": [
            "I'd like to create an Enlightened Singularity."
          ]
          "type": [
            "INTENTION"
          ]
        }
        {
          "description": [
            "I'm looking for Collaborators."
          ]
          "type": [
            "REQUEST"
          ]
        }
      ]

    nodesphere = Nodesphere.digest input
    data = for node in nodesphere.nodes()
      node_data = node.data()
      delete node_data._id    # _id's are random, so remove them before comparing
      node_data
    data.should.deep.equal expected_data

  it 'should add a hash of hashes as expected', ->
    input =
      '2014-12-30T13:33:04-08:00':
        "type": "INTENTION"
        "description": "I'd like to create an Enlightened Singularity."
      '2014-12-30T13:33:03-08:00':
        "type": "REQUEST"
        "description": "I'm looking for Collaborators."

    expected_data =
      [
        {
          "_key": [
            "2014-12-30T13:33:04-08:00"
          ]
          "description": [
            "I'd like to create an Enlightened Singularity."
          ]
          "type": [
            "INTENTION"
          ]
        }
        {
          "_key": [
            "2014-12-30T13:33:03-08:00"
          ]
          "description": [
            "I'm looking for Collaborators."
          ]
          "type": [
            "REQUEST"
          ]
        }
      ]

    nodesphere = Nodesphere.digest input

    data = for node in nodesphere.nodes()
      node_data = node.data()
      delete node_data._id    # _id's are random, so remove them before comparing
      node_data
    data.should.deep.equal expected_data
