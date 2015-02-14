lightsaber  = require 'lightsaber'

{ log, p, pjson } = lightsaber

class Log
  put: (nodesphere) ->
    log nodesphere.to_json()

module.exports = Log



