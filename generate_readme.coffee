# Usage:
#   npm install
#   coffee generate_readme.coffee > README.md

lightsaber  = require 'lightsaber'

{log, p, pretty, type, sha384} = lightsaber

main = ->
  say """
    # NodeSphere

    Simple GET and PUT operations for _nodespheres_, which are simply graphs: collections of nodes and links.

    ## Saving a Graph
    
    ### HTTP PUT request

    For example, suppose you perform an HTTP `PUT`, with a json payload of nodes and links:

    """

  sphere =
    nodes: {}
    edges: {}

  subject   = 'John Perry Barlow'
  predicate = 'published'
  object    = 'A Declaration of Independence of Cyberspace'

  sphere.nodes[sha384 canocial_json content: subject]   = content: subject
  sphere.nodes[sha384 canocial_json content: predicate] = content: predicate
  sphere.nodes[sha384 canocial_json content: object]    = content: object

  edge = {
    subject:   sha384 canocial_json { content: subject }
    predicate: sha384 canocial_json { content: predicate }
    object:    sha384 canocial_json { content: object }
  }

  sphere.edges[sha384 canocial_json edge] = edge

  log indent sane pretty sphere

  say """

  The ID of each node can be any unique string.  In this case we use the SHA-384 of the node's sorted minified JSON.  For example:
      
  """

  log indent sane sha384 canocial_json content: subject

  say """

  is the SHA-384 of 
      
  """

  log indent quote canocial_json content: subject

  say """

  And:
      
  """

  log indent sane sha384 canocial_json edge

  say """

  is the SHA-384 of 
      
  """

  log indent quote sane canocial_json edge

  say """

  Note that the JSON is minified and sorted by keys.
      
  """

  #####

  sphere_packed =
    nodes: 
      [
        sha384 canocial_json { content: subject }
        sha384 canocial_json { content: predicate }
        sha384 canocial_json { content: object }
      ]
    edges: 
      [
        sha384 canocial_json edge
      ]

  say """

  ### HTTP PUT response

  The expected response to the `PUT` request is one or more keys:

  """

  sphere_hash = sha384 canocial_json sphere_packed
  log sane pretty sha384: sphere_hash

  say """

  Where, for example, `#{sane sphere_hash}` is the SHA-384 of the JSON of the entire "packed" sphere:

  """

  log indent quote sane canocial_json sphere_packed

  say """

  Note that the array values are sorted, as well as the object keys.
      
  """

say = (text) ->
  for line in text.split("\n")
    log line.trim()

indent =  (text, line_prefix='    ') ->
  lines = for line in text.split("\n")
    "#{line_prefix}#{line}"
  lines.join "\n"

# replace SHA-384 hex hashes with the first n characters of the hash only
sane = (text, size=8) ->
  text.replace /// \b([0-9a-f]{#{size}})[0-9a-f]{#{384/4-size}}\b ///g, "$1"

quote  = (text) ->
  "'#{text}'"

# argument `obj` can be an oject with one level of key/values deep only.
# values can be numeric, string, or array
canocial_json = minified_json_sorted_by_key = (obj) -> 
  pairs = for key in Object.keys(obj).sort()
    val = obj[key]
    if type(val) is 'object' 
      throw "Error: Object depth of one expected"
    else if type(val) is 'array'
      "#{JSON.stringify key}:#{JSON.stringify val.sort()}"
    else
      "#{JSON.stringify key}:#{JSON.stringify val}"
  "{#{pairs.join(',')}}"

main()
