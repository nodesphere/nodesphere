{ json, log, p, pjson } = require 'lightsaber/lib/log'
{ sha256 } = require 'lightsaber/lib/hash'
canonicalJson = require 'json-stable-stringify'

class Node

  constructor: (@data={}) ->

  id: -> @data.id ? @hash()

  hash: -> "sha256-#{sha256 canonicalJson @data}"

  name: -> @data.name #or @data.id

  get: (propertyName) -> @data[propertyName]

  @randomKey = (key_length=88) ->
    alphabet = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ".split /// ///   # base 58 -- no 0, O, I, or l chars
    chars = for i in [0...key_length]
      alphabet[Math.floor Math.random() * 58]
    chars.join ''

module.exports = Node
