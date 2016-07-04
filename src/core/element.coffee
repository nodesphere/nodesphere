{d, log, pjson} = require 'lightsaber/lib/log'
{randomKey} = require 'lightsaber/lib/key'
multihashing = require 'multihashing'
_ = { isEmpty } = require 'lodash'
canonicalJson = require 'json-stable-stringify'
Buffer = require('buffer/').Buffer
bs58 = require 'bs58'

class Element

  KEY_SIZE_BITS: 256

  constructor: ->
    throw new Error "This is a base class only,
      please override constructor in inheriting classes"

  setKey: (args) ->
    # TODO allow args.idAlgorithm to choose hash alg, or random
    @_id = if args?.id
      args?.id
    else if isEmpty @attrs
      @keySizeBits = args?.keySizeBits or @KEY_SIZE_BITS
      @_id = args?.id or randomKey(bits: @keySizeBits)
    else
      @hash()

  hash: ->
    data = canonicalJson @data()
    buffer = new Buffer data
    multihash = multihashing(buffer, 'sha2-256')
    digest = multihash
    bs58.encode digest

  # for pretty printed JSON:
  # toJson(space: 4)
  #
  toJson: (args = {}) ->
    {replacer, space} = args
    omit = args.omit
    data = @data()
    data = _.omit data, omit if omit
    JSON.stringify data, replacer, space

module.exports = Element
