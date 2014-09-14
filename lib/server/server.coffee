express = require 'express'
Adaptor = require '../adaptor/adaptor.coffee'

app = express()

app.get '/', (req, res) ->
  console.log "root"
  
# app.get /^(.*)$/, (req, res) ->
app.get '/*', (req, res) ->
  source = req.originalUrl.slice 1  # trim leading slash from path
  console.log Adaptor
  Adaptor.serve source
  
port = process.env.PORT or 7000
app.listen port
