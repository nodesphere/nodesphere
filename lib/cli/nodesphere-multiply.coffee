config = require 'commander'
lightsaber = require 'lightsaber'
Adaptor = require "../adaptor/adaptor.coffee"
multiply = require "../algebra/multiply"
{ lodash_snake_case, log, p, pjson, snake_case_keys } = require 'lightsaber'
{ snake_case } = lodash_snake_case

config
  .option '-s, --content-file [path]', 'content nodesphere (JSON)'
  .option '-s, --filter-file [path]', 'filter nodesphere (JSON)'
  .parse process.argv

config = snake_case_keys config

content = Adaptor.get_sync config.content_file
filter  = Adaptor.get_sync config.filter_file
product = multiply content, filter

log product.to_json()
