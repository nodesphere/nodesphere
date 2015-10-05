{ json, log, p, pjson, sha256 } = require 'lightsaber'
canonicalJson = require 'json-stable-stringify'

class Node

  constructor: (@data={}) ->
    @hash = "sha256-#{sha256 canonicalJson @data}"
    @data.id ?= @hash

  id: -> @data.id

  hash: -> @hash

  name: -> @data.name #or @data.id

  @randomKey = (key_length=88) ->
    alphabet = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ".split /// ///   # base 58 -- no 0, O, 1, or l chars
    chars = for i in [0...key_length]
      alphabet[Math.floor Math.random() * 58]
    chars.join ''
module.exports = Node
