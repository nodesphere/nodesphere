config = require 'commander'
lightsaber = require 'lightsaber'
Adaptor = require "../adaptor/adaptor.coffee"
snake_case = require "lodash-node/compat/string/snakeCase"  # pre-release
multiply = require "../algebra/multiply"

{ log, p, pjson } = require 'lightsaber/lib/log'

collect = (val, memo) ->
  memo.push val
  memo

config
  .option '-s, --source-file [path]', 'JSON nodesphere', collect, []
  .parse process.argv

# make all config options available as snake case as well as camel camel case, eg:
# source_gsheet: foo
# as well as:
# sourceGsheet: foo
for own key, value of config
  config[snake_case key] = value

sphere_files = config.source_file
spheres = for sphere_file in sphere_files
  Adaptor.get_sync sphere_file
product = multiply spheres

log product.to_json()
