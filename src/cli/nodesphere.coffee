config = require 'commander'
lightsaber = require 'lightsaber'
Adaptor = require "../adaptor/adaptor"
{ log, p, snake_case_keys } = require 'lightsaber'

config
  .option '-d, --source-dir <source directory>', 'Directory to recursively import'
  .option '-g, --source-gsheet <google spreadsheet ID>', "The ID of the source Google spreadsheet"
  .option '-w, --weights', "Output a collection of numeric weights"
  .option '-t, --target <target>', "Target to write data (default: log)" , 'log'
  .option '--gsheet-orientation <google spreadsheet orientation>', "The orientation of the source Google spreadsheet (default: columns; valid: rows)", 'columns'
  #  .option '-c, --cayley-url <url>', "Cayley (graph DB) server (default: http://127.0.0.1:64210)" , 'http://127.0.0.1:64210'
  .parse process.argv

config = snake_case_keys config
adaptor = new Adaptor config
adaptor.process()
