app = require("express")()
http = require("http").Server(app)
io = require("socket.io")(http)
lightsaber = require "lightsaber"

Adaptor = require "#{__dirname}/../adaptor/adaptor.coffee"

{
  canonical_json
  sha384
} = lightsaber

addresses = {} # names -> addresses
nodes = {}

# Serve static page for manual socket.io actions
app.get "/", (req, res) ->
  res.sendfile "#{__dirname}/index.html"

# GET to eg: [server]/enlightenedstructure.org/Core_Network/
app.get '/*', (nodesphere_request, nodesphere_response) ->
  source = nodesphere_request.originalUrl.slice 1  # trim leading slash from path
  protocol = 'http'  # TODO detect if we are serving from http or https and use that protocol
  source_url = "#{protocol}://#{source}"
  adaptor = new Adaptor source_url
  adaptor.sphere_json source_url, (json) ->
    nodesphere_response.write json


io.on "connection", (socket) ->
  socket.on "getNodesphere", (address) ->
    console.log "getNodesphere"
    {
        "nodes": {
            "e9381b02": "John Perry Barlow",
            "85c3ef1e": "published",
            "b8925d6f": "A Declaration of Independence of Cyberspace"
        },
        "edges": {
            "dbfaa3ef": {
                "subject": "e9381b02",
                "predicate": "85c3ef1e",
                "object": "b8925d6f"
            }
        }
    }    
    
  
  socket.on "getNode", (address) ->
    getNode socket, address
  
  # io.emit('chat message', msg);
  socket.on "getNodeByName", (name) ->
    getNodeByName socket, name
  
  # io.emit('chat message', msg);
  socket.on "createNamedNode", (newNode) ->
    console.log "createNamedNode --> ", newNode
    createNode newNode
  
  # io.emit('chat message', msg);
  socket.on "createNode", (newNode) ->
    console.log "createNode --> ", newNode
    createNode newNode

# io.emit('chat message', msg);

getNodeByName = (socket, name) ->
  node = nodes[addresses[name]]
  socket.emit "receiveNode", node
  console.log node
  node

getNode = (socket, address) ->
  node = nodes[address]
  socket.emit "receiveNode", node
  console.log node
  node

createNode = (newNode) ->
  address = sha384 canonical_json newNode
  nodes[address] = newNode
  
  # Store address (name)
  addresses[newNode.name] = address if newNode.name
  console.log nodes

port = process.env.PORT or 7000
http.listen port, ->
  console.log "listening on :#{port}"

