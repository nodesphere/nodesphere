{pjson, d} = require 'lightsaber/lib/log'
_ = require 'lodash'

class Element

  DEFAULT_KEY_LENGTH: 44  # 58^44 > 2^256

  constructor: ->
    throw new Error "This is a base class only,
      please override constructor in inheriting classes"

  setKey: (args) ->
    @keyLength = args?.keyLength or @DEFAULT_KEY_LENGTH
    @_id = args?.id or randomKey(@keyLength)

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
