class NodeSphere

  rand_key = (key_length=88) ->
    alphabet = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ".split /// ///   # base 58 -- no 0, O, 1, or l chars
    chars = for i in [0...key_length]
      alphabet[Math.floor(Math.random()*alphabet.length)]
    "key-#{chars.join('')}"

  constructor: (@nodes = {}) ->
    @root_node = @nodes[''] ?= {}
    @keys = [ rand_key 44 ]

  key: ->
    @keys[0] or raise("No keys found")



module.exports = NodeSphere
