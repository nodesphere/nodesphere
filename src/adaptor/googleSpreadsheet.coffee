request = require 'axios'
Promise = require 'bluebird'
{ log, d } = require 'lightsaber/lib/log'
{ camelCase, startsWith } = require 'lodash'

Sphere = require '../core/sphere'

class GoogleSpreadsheet

  URL_PATTERN = /// ^\s*https?://.+\.google.com.*/spreadsheet/.*key=([\w-]{44}) ///

  @understands: (url) ->
    URL_PATTERN.exec(url)?

  @create: (options = {}) ->
    Promise.resolve new GoogleSpreadsheet

  fetch: (@options={}) ->
    for key, value of @options
      if key isnt camelCase(key)
        @options[camelCase(key)] = value

    @options.orientation ?= @options.gsheetOrientation ?= 'columns'   # support legacy option name
    @options.id ?= @options.gsheetId ?= @options.sourceGsheet         # support legacy option name
    throw new Error "Either ID or URL required" unless @options.url? or @options.id?
    if @options.url
      @options.id = URL_PATTERN.exec(@options.url)[1]
      throw new Error "Could not parse spreadsheet ID from URL: #{@options.url}" unless @options.id
      @options.url = null
    @json_url = "https://spreadsheets.google.com/feeds/cells/#{@options.id}/1/public/basic?alt=json"

    request
      url: @json_url
    .then (response) =>
      @sphere_from response.data
    .catch (error) =>
      throw new Error "Error getting '#{@json_url}': #{error}"

  sphere_from: (spreadsheet) =>
    sphere = new Sphere
    sphere.attr 'url', @json_url
    filter = sphere.addNode {type: 'filter', rank: 0}

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
      primary_header = primary_headers[primary_index]
      secondary_header = secondary_headers[secondary_index]

      if primary_index > 1 and secondary_index > 1
        sphere.triple primary_header, secondary_header or null, text
        sphere.addEdge start: filter, end: primary_header

    sphere

  each_cell: (spreadsheet, callback) =>
    cells = spreadsheet.feed.entry
    for cell in cells
      text = cell.content.$t
      id = cell.id.$t
      [match, row, col] = /R(\d+)C(\d+)$/.exec id  # eg: for row 3, col 2, the ID (a URI) ends in R3C2
      if @options.orientation == 'columns'
        callback text, Number(col), Number(row)
      else if @options.orientation == 'rows'
        callback text, Number(row), Number(col)
      else throw new Error "Unexpected value for options.orientation: '#{@options.orientation}'"

module.exports = GoogleSpreadsheet
