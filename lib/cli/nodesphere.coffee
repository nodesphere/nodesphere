config = require 'commander'
lightsaber = require 'lightsaber'
Adaptor = require "../adaptor/adaptor.coffee"
snake_case = require "lodash-node/compat/string/snakeCase"  # pre-release

{ log, p } = lightsaber

config
  .option '-d, --source-dir <source directory>', 'Directory to recursively import'
  .option '-g, --source-gsheet <google spreadsheet ID>', "The ID of the source Google spreadsheet"
  .option '-t, --target <target>', "Target to write data (default: log)" , 'log'
  .option '--gsheet-orientation <google spreadsheet orientation>', "The orientation of the source Google spreadsheet (default: columns; valid: rows)", 'columns'
  #  .option '-c, --cayley-url <url>', "Cayley (graph DB) server (default: http://127.0.0.1:64210)" , 'http://127.0.0.1:64210'
  .parse process.argv

# make all config options available as snake case as well as camel camel case, eg:
# source_gsheet: foo
# as well as:
# sourceGsheet: foo
for own key, value of config
  config[snake_case key] = value

adaptor = new Adaptor config
adaptor.process()
