require('chai').should()
lightsaber = require 'lightsaber'
{ lodash_snake_case, log, p } = lightsaber
{ reject } = lodash_snake_case

Nodesphere = require '../../src/core/nodesphere'
Node = require '../../src/core/node'

describe 'Nodesphere.digest', ->

  it 'should add an array of single-attribute hashes as a single node', ->
    input =
      [
        { "_key": "Ripple" }
        { "tag": "Blockchain" }
      ]

    expected_data =
      [
        [
          { "_key": "Ripple" }
          { "tag": "Blockchain" }
        ]
      ]

    nodesphere = Nodesphere.digest input
    nodesphere.node_data(omit_keys: '_id').should.deep.equal expected_data

  it 'should add an array of multiple-attribute hashes as multiple nodes', ->
    input =
      [
        {
          "description": "I'd like to create an Enlightened Singularity."
          "type": "INTENTION"
        }
        {
          "description": "I'm looking for Collaborators."
          "type": "REQUEST"
        }
      ]

    expected_data =
      [
        [
          { "description": "I'd like to create an Enlightened Singularity." }
          { "type": "INTENTION" }
        ]
        [
          { "description": "I'm looking for Collaborators." }
          { "type": "REQUEST" }
        ]
      ]

    nodesphere = Nodesphere.digest input
    nodesphere.node_data(omit_keys: '_id').should.deep.equal expected_data

  it 'should add an array of hashes whose values are arrays as expected', ->
    input = [
      {
        "_key": [ "time poem" ]
        "time": [ 3 ]
      }
      {
        "_key": ["beauty poem"]
        "beautiful": [2]
      }
    ]

    expected_data =
      [
        [
          {"_key": "time poem"}
          {"time": 3}
        ]
        [
          {"_key": "beauty poem"}
          {"beautiful": 2}
        ]
      ]

    nodesphere = Nodesphere.digest input
    nodesphere.node_data(omit_keys: '_id').should.deep.equal expected_data

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
        [
          { "_key": "2014-12-30T13:33:04-08:00" }
          { "description": "I'd like to create an Enlightened Singularity." }
          { "type": "INTENTION" }
        ]
        [
          { "_key": "2014-12-30T13:33:03-08:00" }
          { "description": "I'm looking for Collaborators." }
          { "type": "REQUEST" }
        ]
      ]

    nodesphere = Nodesphere.digest input
    nodesphere.node_data(omit_keys: '_id').should.deep.equal expected_data

describe 'Nodesphere#weights', ->

  it 'should return a new nodesphere with weights of keywords', ->
    nodesphere = new Nodesphere

    nodesphere.add_node new Node [
      {_key: "Ethereum"}
      {tag: "Blockchain"}
      {'contract substrate': "Blockchain"}
    ]

    nodesphere.add_node new Node [
      {_key: "Ripple"}
      {tag: "Blockchain"}
    ]

    weights = nodesphere.weight_sphere()

    weights.node_data().should.deep.equal [
      [
        {_key: "Ethereum"}
        {Blockchain: 2}
      ]
      [
        {_key: "Ripple"}
        {Blockchain: 1}
      ]
    ]
