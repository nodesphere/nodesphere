path = require 'path'
chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
chai.use chaiAsPromised
should = chai.should()
{ json, log, d, pjson, run } = require 'lightsaber'
{ keys } = require 'lodash'
ipfsd = require 'ipfsd-ctl'

ipfsAdaptor = require '../../lib/adaptor/ipfs'
Sphere = require '../../lib/core/sphere'

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

  it 'can fetch an IPFS tree', ->
    @timeout 30000
    # result = run "ipfs init", quiet: true, relaxed: true
    result = run "#{ipfsNode.exec} add -r -q #{path.join __dirname, '../fixtures/a'} | tail -n 1"#, quiet: true
    hash = result.output.trim()
    adaptor.fetch rootNodeId: hash
    .then (sphere) =>
      sphere.should.be.instanceof Sphere
      keys(sphere.nodes).sort().should.deep.equal [
        "QmSFxnK675wQ9Kc1uqWKyJUaNxvSc2BP5DbXCD3x93oq61"
        "QmdytmR4wULMd3SLo6ePF4s3WcRHWcpnJZ7bHhoj3QB13v"
        "QmfAHGP6WXEEsK75JbnXdQkzXojvmrHLSyqBMxdcndQASU"
      ]
      keys(sphere.edges).sort().should.deep.equal [
        "QmfAHGP6WXEEsK75JbnXdQkzXojvmrHLSyqBMxdcndQASU -> QmSFxnK675wQ9Kc1uqWKyJUaNxvSc2BP5DbXCD3x93oq61"
        "QmfAHGP6WXEEsK75JbnXdQkzXojvmrHLSyqBMxdcndQASU -> QmdytmR4wULMd3SLo6ePF4s3WcRHWcpnJZ7bHhoj3QB13v"
      ]

  it 'can add a file', ->
    @timeout 10000
    adaptor.put content: "Plz add me!\n"
      .should.eventually.deep.equal ['Qma4hjFTnCasJ8PVp3mZbZK5g2vGDT4LByLJ7m8ciyRFZP']
