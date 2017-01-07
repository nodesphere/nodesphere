{ expect } = require 'chai'
{ some, values } = require 'lodash'
{ d, pjson } = require 'lightsaber'

{ assertEdge } = require '../testHelpers'

Sphere = require '../../lib/core/sphere'
GoogleSpreadsheet = require '../../lib/adaptor/googleSpreadsheet'

describe 'GoogleSpreadsheet Adaptor', ->
  describe '#sphere_from', ->
    it 'builds a sphere from spreadsheet data', ->
      gsheet = new GoogleSpreadsheet
      gsheet.options = orientation: 'rows'
      spreadsheet =
        feed:
          entry: [
            {
              id:
                $t: '...R1C1'
              content:
                $t: ''
            }
            {
              id:
                $t: '...R1C2'
              content:
                $t: 'favorite color'
            }
            {
              id:
                $t: '...R1C3'
              content:
                $t: 'middle name'
            }
            {
              id:
                $t: '...R2C1'
              content:
                $t: 'Alice'
            }
            {
              id:
                $t: '...R2C2'
              content:
                $t: 'Violet'
            }
            {
              id:
                $t: '...R2C3'
              content:
                $t: 'Violet'
            }
          ]

      sphere = gsheet.sphere_from spreadsheet
      expect(sphere).to.be.instanceof Sphere
      edges = values sphere.edgesData()

      assertEdge sphere,
        subject: 'Alice'
        predicate: {name: 'favorite color'}
        object: 'Violet'

      assertEdge sphere,
        subject: 'Alice'
        predicate: {name: 'middle name'}
        object: 'Violet'
