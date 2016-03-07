chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
chai.use chaiAsPromised
should = chai.should()

{ json, log, p, pjson } = require 'lightsaber'

ipfsd = require 'ipfsd-ctl'
ipfsAdaptor = require '../../lib/adaptor/ipfs'

DEBUG = 0
debug = -> log arguments... if DEBUG

describe 'IPFS Adaptor', ->
  adaptor = undefined
  ipfsNode = undefined

  before (done) ->
    @timeout 20000
    debug 'ipfs node setup'
    ipfsd.disposable (err, node) ->
      throw err if err
      debug 'ipfs init done'
      ipfsNode = node
      ipfsNode.startDaemon (err, ignore) ->
        throw err if err
        debug 'ipfs daemon running'
        ipfsAdaptor.create host: ipfsNode.apiAddr
          .then (_adaptor) =>
            adaptor = _adaptor
            debug 'ipfs adaptor created'
            done()

  it 'exists', ->
    should.exist adaptor

  it 'can add a file', ->
    @timeout 10000
    adaptor.put content: "Plz add me!\n"
      .should.eventually.deep.equal ['Qma4hjFTnCasJ8PVp3mZbZK5g2vGDT4LByLJ7m8ciyRFZP']
