{pjson, d} = require 'lightsaber/lib/log'

class Identified

  DEFAULT_KEY_LENGTH: 44  # 58^44 > 2^256

  setKey: (args) ->
    @keyLength = args?.keyLength or @DEFAULT_KEY_LENGTH
    @_id = args?.id or randomKey(@keyLength)

  randomKey = (keyLength) ->
    alphabet = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ".split /// ///   # base 58 -- no 0, O, I, or l chars
    chars = for i in [0...keyLength]
      alphabet[Math.floor Math.random() * 58]
    chars.join ''

module.exports = Identified
