path = require 'path'
app = require("express")()
http = require("http").Server(app)
io = require("socket.io")(http)
{
  canonical_json
  p
  sha384
} = require "lightsaber"
Adaptor = require "../adaptor/adaptor.coffee"

APP_ROOT = path.resolve __dirname, '../..'
PUB_ROOT = path.resolve APP_ROOT, 'pub'
# DEMO_DATA = 'docs.google.com/spreadsheet/ccc?key=0AnVa7rwgRKG2dDl5QVhBajZaMjNBbjBTSkZ1OGJVdlE'

addresses = {} # names -> addresses
nodes = {}

# favicon requests > /dev/null
app.get "/favicon.ico", ->

app.get "/", (req, res) ->
  # res.sendFile "#{PUB_ROOT}/index.html"
  res.redirect "http://nodesphere.org/"

# GET to eg: 
#   - [server]/enlightenedstructure.org/Core_Network/
#   - [server]/docs.google.com/spreadsheet/ccc?key=0AnVa7rwgRKG2dEFxdUJwc2FaMlRGLXBOclNYY3F5VXc
app.get '/*', (nodesphere_request, nodesphere_response) ->
  source = nodesphere_request.originalUrl.slice 1  # trim leading slash from path
  # if source.length is 0 then source = DEMO_DATA
  protocol = 'http'  # TODO detect if we are serving from http or https and use that protocol
  source_url = "#{protocol}://#{source}"
  adaptor = new Adaptor source_url
  adaptor.sphere_json source_url, (json) ->
    nodesphere_response.write json


io.on "connection", (socket) ->
  socket.on "getNodesphere", (address) ->
    adaptor = new Adaptor address
    adaptor.sphere_json address, (json) -> socket.emit "receiveNodesphere", json
  
  # socket.on "getNode", (address) ->
  #   getNode socket, address
  
  # # io.emit('chat message', msg);
  # socket.on "getNodeByName", (name) ->
  #   getNodeByName socket, name
  
  # # io.emit('chat message', msg);
  # socket.on "createNamedNode", (newNode) ->
  #   console.log "createNamedNode --> ", newNode
  #   createNode newNode
  
  # # io.emit('chat message', msg);
  # socket.on "createNode", (newNode) ->
  #   console.log "createNode --> ", newNode
  #   createNode newNode

# io.emit('chat message', msg);

# getNodeByName = (socket, name) ->
#   node = nodes[addresses[name]]
#   socket.emit "receiveNode", node
#   console.log node
#   node

# getNode = (socket, address) ->
#   node = nodes[address]
#   socket.emit "receiveNode", node
#   console.log node
#   node

# createNode = (newNode) ->
#   address = sha384 canonical_json newNode
#   nodes[address] = newNode
  
#   # Store address (name)
#   addresses[newNode.name] = address if newNode.name
#   console.log nodes

port = process.env.PORT or 7000
http.listen port, ->
  console.log "listening on port #{port}"

