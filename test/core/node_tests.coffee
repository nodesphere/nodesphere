require('chai').should()
{ log, p } = require 'lightsaber'

Node = require '../../lib/core/node'

describe 'new Node()', ->

  it 'should handle known JS types', ->
    node = new Node
      day: 25
      time: '4:44pm'
      date: new Date 'Mon Jan 26 2015 16:43:22 GMT+0000 (UTC)'
      requires: null
      dependents: undefined
      include: true
      value: -133.2
      score: 10e10
      pattern: /^foobar$/
      func: `function () { return 'foobar' }`

    node.props().should.deep.equal
      day: [25]
      time: ['4:44pm']
      date: ['2015-01-26T16:43:22.000Z']
      requires: [null]
      dependents: [null]
      include: [true]
      value: [-133.2]
      score: [10e10]
      pattern: ['/^foobar$/']
      func: ["function () { return 'foobar' }"]

  it 'should allow arrays of values', ->
    node = new Node
      'Node Store': ['MAIDSAFE', 'telehash']
      'Node Secure': ['MAIDSAFE', 'Tahoe LAFS']

    node.props().should.deep.equal
      'Node Store': ['MAIDSAFE', 'telehash']
      'Node Secure': ['MAIDSAFE', 'Tahoe LAFS']

describe 'Node#weights', ->

  it 'should keep existing weights intact', ->
    node = new Node
      the: 25
      time: 3
      is: 31

    node.add_data 'time', 1
    node.add_data 'time', 1

    node.weights().should.deep.equal
      the: 25
      time: 5
      is: 31

  it 'should weight all *values* with weight of 1 if non-numeric values are present', ->
    node = new Node
      _id: 'xyz123'
      _key: 'Node Services'
      'Node Store': ['MAIDSAFE', 'telehash']
      'Node Secure': ['MAIDSAFE', 'Tahoe LAFS']

    node.weights().should.deep.equal
      _key: 0
      _id: 0
      'Node Store': 0
      'Node Secure': 0
      'xyz123': 1
      'Node Services': 1
      'MAIDSAFE': 2
      'telehash': 1
      'Tahoe LAFS': 1
