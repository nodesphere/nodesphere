express = require 'express'
Adaptor = require '../adaptor/adaptor.coffee'
{ p }   = require 'lightsaber'

app = express()

app.get '/', (req, res) ->
  console.log "root"
  
# app.get /^(.*)$/, (req, res) ->
app.get '/*', (nodesphere_request, nodesphere_response) ->
  source = nodesphere_request.originalUrl.slice 1  # trim leading slash from path
  protocol = 'http'  # TODO detect if we are serving from http or https and use that protocol
  source_url = "#{protocol}://#{source}"
  adaptor = new Adaptor source_url
  adaptor.sphere_json source_url, (json) ->
    nodesphere_response.write json
  
port = process.env.PORT or 7000
app.listen port
