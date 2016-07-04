{pjson, d} = require 'lightsaber/lib/log'
multihashing = require 'multihashing'
_ = { isEmpty } = require 'lodash'
canonicalJson = require 'json-stable-stringify'
Buffer = require('buffer/').Buffer
bs58 = require 'bs58'

class Element

  DEFAULT_KEY_LENGTH: 44  # 58^44 > 2^256

  constructor: ->
    throw new Error "This is a base class only,
      please override constructor in inheriting classes"

  setKey: (args) ->
    # TODO allow args.idAlgorithm to choose hash alg, or random
    @_id = if args?.id
      args?.id
    else if isEmpty @data()
      @keyLength = args?.keyLength or @DEFAULT_KEY_LENGTH
      @_id = args?.id or randomKey(@keyLength)
    else
      @hash()

  hash: ->
    data = canonicalJson @data()
    buffer = new Buffer data
    multihash = multihashing(buffer, 'sha2-256')
    digest = multihash
    bs58.encode digest

  randomKey = (keyLength) ->
    alphabet = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ".split /// ///   # base 58 -- no 0, O, I, or l chars
    chars = for i in [0...keyLength]
      alphabet[Math.floor Math.random() * 58]
    chars.join ''

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
