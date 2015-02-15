config = require 'commander'
lightsaber = require 'lightsaber'
Adaptor = require "../adaptor/adaptor"
multiply = require "../algebra/multiply"
{ log, p, pjson, snake_case_keys } = require 'lightsaber'

config
  .option '-s, --content-file [path]', 'content nodesphere (JSON)'
  .option '-s, --filter-file [path]', 'filter nodesphere (JSON)'
  .parse process.argv

config = snake_case_keys config

content = Adaptor.get_sync config.content_file
filter  = Adaptor.get_sync config.filter_file
product = multiply content, filter

log product.to_json()
