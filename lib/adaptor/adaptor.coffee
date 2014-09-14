http = require 'http-request'

RevealDeck = require './reveal_deck.coffee'

class Adaptor

  sphere_json: (source_url, callback) ->
    http.get source_url, (source_error, source_response) ->
      if source_error
        console.error source_error
      else
        # res.code
        # res.headers
        content = res.buffer.toString()

        # initially, we support only Reveal:
        reveal_deck = new RevealDeck
          content: content
          url: source_url

        reveal_deck.as_sphere (nodesphere) ->
          callback nodesphere.to_json()

        #   return the json as the response plz : )

module.exports = Adaptor
