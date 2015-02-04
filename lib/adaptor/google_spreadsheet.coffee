http = require 'http-request'
lightsaber  = require 'lightsaber'
lodash = require 'lodash'
Nodesphere = require '../core/nodesphere'

starts_with = lodash.startsWith
{ log, p } = lightsaber

class GoogleSpreadsheet

  URL_PATTERN = /// ^\s*https?://.+\.google.com.*/spreadsheet/.*key=([\w-]{44}) ///

  @understands: (url) ->
    URL_PATTERN.exec(url)?

  constructor: (@options={}) ->
    @options.id ?= @options.source_gsheet
    throw "Either ID or URL required" unless @options.url? or @options.id?
    @options.gsheet_orientation ?= 'columns'
    if @options.url
      @options.id = URL_PATTERN.exec(@options.url)[1]
      throw "Could not parse spreadsheet ID from URL: #{@options.url}" unless @options.id
      @options.url = null

    @json_url = "https://spreadsheets.google.com/feeds/cells/#{@options.id}/1/public/basic?alt=json"
    # @json_url = if @options.id
    #   "https://spreadsheets.google.com/feeds/cells/#{@options['id']}/1/public/basic?alt=json"
    # else if @options.fixture
    #   "/fixtures/#{@options.fixture}.json"
    # else
    #   throw "GoogleSpreadsheet#as_sphere expected options.id or options.fixture, got neither"

  as_sphere: (callback) ->
    http.get @json_url, (error, response) =>
      if error
        throw "Error getting '#{@json_url}': #{error}"
      else if not starts_with response.headers?['content-type'], 'application/json'
        throw "The expected spreadsheet JSON is not publicly available at:\n#{@json_url}"
      else
        spreadsheet = JSON.parse response.buffer.toString()
        sphere = @sphere_from_json spreadsheet
        callback sphere

  sphere_from_json: (spreadsheet) =>
    sphere = new Nodesphere()
    sphere.meta 'url', @json_url

    # populate row headers and col headers:
    primary_headers = {}
    secondary_headers = {}
    @each_cell spreadsheet, (text, primary_index, secondary_index) =>
      if primary_index is 1
        secondary_headers[secondary_index] = text
      if secondary_index is 1
        primary_headers[primary_index] = text

    # populate nodes:
    @each_cell spreadsheet, (text, primary_index, secondary_index) =>
      # primary_header = primary_headers[primary_index]
      secondary_header = secondary_headers[secondary_index]

      if primary_index > 1 and secondary_index > 1
        sphere.add_data primary_headers[primary_index], secondary_header or '', text

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
