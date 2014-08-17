define (require, exports, module) ->

  # NodeSphere        = require 'core/node_sphere'
  # { log, p }        = require 'lightsaber/log'

  ####################################################################
  class GoogleSpreadsheet
  ####################################################################

    @as_sphere: (options, callback) ->
      json_url = if options.id
        "https://spreadsheets.google.com/feeds/cells/#{options['id']}/1/public/basic?alt=json"
      else if options.fixture
        "/fixtures/#{options.fixture}.json"
      else 
        throw "to_sphere expected options.id or options.fixture, got neither"
      $.getJSON json_url, (json) ->
        sphere = GoogleSpreadsheet.sphere_from_json json, options
        callback sphere

    @sphere_from_json: (spreadsheet, options) ->
      sphere = new NodeSphere()

      # populate row headers and col headers:
      primary_headers = {}
      secondary_headers = {}
      @each_cell spreadsheet, options, (text, primary_index, secondary_index) =>
        primary_headers[primary_index] = text if secondary_index is 1
        secondary_headers[secondary_index] = text if primary_index is 1

      # populate harmonics:
      harmonics = {}
      @each_cell spreadsheet, options, (text, primary_index, secondary_index) =>
        if secondary_headers[secondary_index]?.toLowerCase() is 'harmonic'
          harmonics[primary_index] = text unless text.toLowerCase() is 'harmonic'

      # populate nodes:
      @each_cell spreadsheet, options, (text, primary_index, secondary_index) =>
        primary_header = primary_headers[primary_index]
        secondary_header = secondary_headers[secondary_index] 

        # eg: nodesphere has metadata '1: Beauty': 'Fire'
        sphere.add_meta_if primary_header, text

        # eg: '1: Beauty' node has metadata 'Codon Ring': 'Fire'
        sphere.insert_if primary_header, secondary_header or '(blank)', text 

        # eg: 'Codon Ring' node has metadata 'Fire': '1: Beauty'
        sphere.insert_if secondary_header, text, primary_header

        if secondary_header?.toLowerCase() is 'direct link'
          sphere.insert_if primary_header, 'url', text

      # console.log sphere
      sphere

    @each_cell: (spreadsheet, options, callback) ->
      cells = spreadsheet.feed.entry
      for cell in cells
        text = cell.content.$t?.trim()
        id = cell.id.$t
        [match, row, col] = /R(\d+)C(\d+)$/.exec id  # eg: for row 3, col 2, the ID (a URI) ends in R3C2 
        if options.gsheet_orientation == 'columns'
          callback text, Number(col), Number(row)
        else if options.gsheet_orientation == 'rows'
          callback text, Number(row), Number(col)
        else throw "Unexpected value for options.gsheet_orientation: '#{options.gsheet_orientation}'"
