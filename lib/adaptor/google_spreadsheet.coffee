http = require 'http-request'
lightsaber  = require 'lightsaber'
Nodesphere = require '../core/nodesphere'

{
  log
  p
} = lightsaber

class GoogleSpreadsheet

  URL_PATTERN = /// ^\s*https?://.+\.google.com.*/spreadsheet/.*key=([\w-]{44}) ///

  @understands: (url) ->      
    URL_PATTERN.exec(url)?

  constructor: (@options={}) ->
    @options.gsheet_orientation ?= 'columns'
    if @options.url
      @options.id = URL_PATTERN.exec(@options.url)[1]
      @options.url = null

    @json_url = if @options.id
      "https://spreadsheets.google.com/feeds/cells/#{@options['id']}/1/public/basic?alt=json"
    else if @options.fixture
      "/fixtures/#{@options.fixture}.json"
    else 
      throw "GoogleSpreadsheet#as_sphere expected options.id or options.fixture, got neither"

  as_sphere: (callback) ->
    http.get @json_url, (error, response) =>
      if error
        console.error error
      else
        spreadsheet = JSON.parse response.buffer.toString()
        sphere = @sphere_from_json spreadsheet
        callback sphere

  sphere_from_json: (spreadsheet) =>
    sphere = new Nodesphere()

    # populate row headers and col headers:
    primary_headers = {}
    secondary_headers = {}
    @each_cell spreadsheet, (text, primary_index, secondary_index) =>
      primary_headers[primary_index] = text if secondary_index is 1
      secondary_headers[secondary_index] = text if primary_index is 1

    # populate nodes:
    @each_cell spreadsheet, (text, primary_index, secondary_index) =>
      primary_header = primary_headers[primary_index]
      secondary_header = secondary_headers[secondary_index] 

      if primary_index > 1 and secondary_index > 1
        # eg: '1: Beauty' node has metadata 'Codon Ring': 'Fire'
        sphere.put_edge primary_header, secondary_header or null, text

      if secondary_header?.toLowerCase() in ['direct link', 'url']
        sphere.put_edge primary_header, 'url', text

    sphere

  each_cell: (spreadsheet, callback) =>
    cells = spreadsheet.feed.entry
    for cell in cells
      text = cell.content.$t
      id = cell.id.$t
      [match, row, col] = /R(\d+)C(\d+)$/.exec id  # eg: for row 3, col 2, the ID (a URI) ends in R3C2 
      if @options.gsheet_orientation == 'columns'
        callback text, Number(col), Number(row)
      else if @options.gsheet_orientation == 'rows'
        callback text, Number(row), Number(col)
      else throw "Unexpected value for options.gsheet_orientation: '#{@options.gsheet_orientation}'"

module.exports = GoogleSpreadsheet