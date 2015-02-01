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

    data = node.data()
    data.should.contain {day: 25}
    data.should.contain {time: '4:44pm'}
    data.should.contain {date: '2015-01-26T16:43:22.000Z'}
    data.should.contain {requires: null}
    data.should.contain {dependents: null}
    data.should.contain {include: true}
    data.should.contain {value: -133.2}
    data.should.contain {score: 10e10}
    data.should.contain {pattern: '/^foobar$/'}
    data.should.contain {func: "function () { return 'foobar' }"}

  it 'should allow arrays of values', ->
    node = new Node
      'Node Store': ['MAIDSAFE', 'telehash']
      'Node Secure': ['MAIDSAFE', 'Tahoe LAFS']

    data = node.data()
    data.should.contain {'Node Store': 'MAIDSAFE'}
    data.should.contain {'Node Store': 'telehash'}
    data.should.contain {'Node Secure': 'MAIDSAFE'}
    data.should.contain {'Node Secure': 'Tahoe LAFS'}

describe 'Node#data', ->

  it 'should sort attributes by key and value', ->
    node = new Node
    node.add_data 'friend', 'Carol'
    node.add_data '_name', 'foo'
    node.add_data 'friend', 'Bob'
    node.add_data 'Friend', 'Sam'
    node.add_data 'education', 'MS Comp Sci'
    node.add_data 'gift', 'simplicity'
    
    node.data().should.deep.equal [
      {'_name': 'foo'              }
      {'education': 'MS Comp Sci'  }
      {'friend': 'Bob'             }
      {'friend': 'Carol'           }
      {'Friend': 'Sam'             }
      {'gift': 'simplicity'        }
    ]

  it 'should omit attributes by key if requested', ->
    node = new Node
    node.add_data 'friend', 'Carol'
    node.add_data 'friend', 'Bob'
    node.add_data 'Friend', 'Sam'

    node.data(omit_keys: 'friend').should.deep.equal [
      {'Friend': 'Sam' }
    ]

describe 'Node#weights', ->

  it 'should keep existing weights intact', ->
    node = new Node [
      {the: 25}
      {time: 1}
      {time: 2}
      {time: 3}
      {is: 31}
    ]

    node.weights().should.deep.equal
      the: 25
      time: 6
      is: 31

  it 'should keep existing weights intact, even when non-numeric metadata is present', ->
    node = new Node
      _id: 'Q5pvcx41GjN29'
      _key: 'Node Services'
      'MAIDSAFE': 2
      'telehash': 0.5
      'Tahoe LAFS': 0.5

    node.weights().should.deep.equal
      _key: 0
      _id: 0
      'Q5pvcx41GjN29': 1
      'Node Services': 1
      'MAIDSAFE': 2
      'telehash': 0.5
      'Tahoe LAFS': 0.5

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
