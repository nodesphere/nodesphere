http = require 'http-request'

GoogleSpreadsheet = require "./google_spreadsheet.coffee"
RevealDeck        = require "./reveal_deck.coffee"

class Adaptor

  @sphere_json: (source_url, callback) ->
    if GoogleSpreadsheet.understands source_url
      gsheet = new GoogleSpreadsheet url: source_url, gsheet_orientation: 'rows'
      gsheet.as_sphere (nodesphere) -> 
        callback nodesphere.to_json()
    else 
      console.error "No known adaptor for the content retrieved from #{source_url}"
      # http.get source_url, (source_error, source_response) ->
      #   if source_error
      #     console.error source_error
      #   else
      #     # content = source_response.buffer.toString()
      #     # if RevealDeck.understands content
      #     #   reveal_deck = new RevealDeck
      #     #     content: content
      #     #     url: source_url
      #     #   nodesphere = reveal_deck.as_sphere()
      #     #   callback nodesphere.to_json()
      #     # else 

module.exports = Adaptor
