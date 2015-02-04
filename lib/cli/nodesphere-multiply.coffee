config = require 'commander'
lightsaber = require 'lightsaber'
Adaptor = require "../adaptor/adaptor.coffee"
snake_case = require("lodash").snakeCase
multiply = require "../algebra/multiply"

{ log, p, pjson } = require 'lightsaber/lib/log'

config
  .option '-s, --content-file [path]', 'content nodesphere (JSON)'
  .option '-s, --filter-file [path]', 'filter nodesphere (JSON)'
  .parse process.argv

# make all config options available as snake case as well as camel camel case, eg:
# source_gsheet: foo
# as well as:
# sourceGsheet: foo
for own key, value of config
  config[snake_case key] = value

content = Adaptor.get_sync config.content_file
filter  = Adaptor.get_sync config.filter_file
product = multiply content, filter

log product.to_json()
