# Nodesphere

> Note: Nodesphere is currently pre-alpha, and things are likely to change. We don't recommend you use it in production yet.

Nodesphere is an interchange format for node networks. It has three primary objectives:

1. Create interoperability among graph visualization interfaces
2. Provide adaptors to connect these interfaces to personal data ecosystems,
including social network data, online drives, and ultimately, any public or private data
3. Abstract data storage and retrieval, allowing transitions
from traditional server & database systems toward secure, distributed public and private storage,
as these systems become practical and performant

## Philosophical

Everything we want to share is a graph, which can be seen as a group of knowledge nodes.
We think of this as a "sphere" of nodes; thus the name _nodesphere_.
Nodesphere is designed to help enable the curation, sharing, visualization, and navigation of all your graph data.


## Terminology

### Node

Everything we care to reference is a _node_, which is simply an _ID_ with _attributes_ attached.
For example, a movie, a person, or a knowledge base are all _nodes_.

We define a `Node` as our base concept:
- Nodes are composed of a list of attributes
- Each attribute has a unique key (a string)
- Each attribute can have multiple values (of type string, number, boolean or null)

An example of a Node:

    [
        { "_key": "Maidsafe" },
        { "node service": "Node Foundation" },
        { "node service": "Node Store" },
        { "tag": "Distributed File System" },
        { "URL": "http://maidsafe.net/" }
    ]
### ID

Every node has one ID at its core.
These IDs can be any string, however a 512 bit namespace is recommended
to ensure the likelihood of uniqueness in the global interoperability graph.

IDs are typically random -- Nodesphere itself creates an 88 characters string
using the [base 58](http://en.wikipedia.org/wiki/Base58) alphabet,
meeting the 512 bit namespace recommendation (58^88 > 2^512).

### Attributes

Attributes have two parts, a name (key) and a value.
For example the node referring to this document might have the following attributes:

- tag: Nodesphere
- tag: Giant Global Graph
- created at: 12 November 2014

### Nodesphere

A nodesphere is a list of nodes, optionally also including a metadata node, which may summarize the other nodes,
as in the example below:

    [
        [
            { "_key": "metadata" },
            { "node": "Camlistore" },
            { "node": "Maidsafe" },
            { "node": "telehash" },
            { "url": "https://spreadsheets.google.com/feeds/cells/0AnVa7rwgRKG2dEtWOEEzOXVIRWo3Tk1VQ3BJcHVkbmc/1/public/basic?alt=json" }
        ],
        [
            { "_key": "Maidsafe" },
            { "node service": "Node Foundation" },
            { "node service": "Node Store" },
            { "tag": "Distributed File System" },
            { "URL": "http://maidsafe.net/" }
        ],
        [
            { "_key": "telehash" },
            { "node service": "Node Foundation" },
            { "node service": "Node Store" },
            { "tag": "Distributed Hash Table" },
            { "URL": "http://telehash.org/" }
        ],
        [
            { "_key": "Camlistore" },
            { "node service": "Node Foundation" },
            { "node service": "Node Store" },
            { "node service": "Node Sync" },
            { "tag": "Distributed File System" },
            { "URL": "http://camlistore.org/" }
        ]
    ]
## Graph Modeling

Every _nodesphere_ is modeled as a directed multigraph (multidigraph),
also known as a [quiver](https://en.wikipedia.org/wiki/Quiver_%28mathematics%29) -- that is, a directed graph allowing for multiple edges which share the same vertices.

Each _node_ is modeled as a [vertex](https://en.wikipedia.org/wiki/Vertex_%28graph_theory%29), where the label on the vertex is the _ID_ of the _node_.  (Note that we speak only of graph vertices, never "graph nodes", to avoid confusion with nodesphere's concept of a node.)

Each _attribute_ is modeled as an [arc (directed edge)](https://en.wikipedia.org/wiki/Glossary_of_graph_theory#Direction), which has a tail (the vertex of the _node_), a label (the attribute name), and a head (the vertex of the attribute value).

Both the _vertices_ and the _arcs_ are [labeled](https://en.wikipedia.org/wiki/Graph_labeling), where the labels are the graph data itself.


# Examples:

## Resource crunching via JSON endpoints:

This demo deployment of `nodepshere`:

<https://peaceful-journey-7085.herokuapp.com/docs.google.com/spreadsheet/ccc?key=0AnVa7rwgRKG2dEtWOEEzOXVIRWo3Tk1VQ3BJcHVkbmc>

Fetches the JSON from the corresponding Google spreadsheet:

<https://docs.google.com/spreadsheet/ccc?key=0AnVa7rwgRKG2dEtWOEEzOXVIRWo3Tk1VQ3BJcHVkbmc>

-- or indeed any spreadsheet "published to the web".

## Command Line

First:
    
    npm install -g nodesphere

Crunch google spreadsheet into nodesphere:

    nodesphere --source-gsheet 0AnVa7rwgRKG2dEtWOEEzOXVIRWo3Tk1VQ3BJcHVkbmc --gsheet-orientation rows

Crunch local directory into word frequency counts:
    
    nodesphere --source-dir some/directory

Multiply two local json nodespheres:
    
    nodesphere-multiply --content-file ./examples/sphere1.json --filter-file ./examples/sphere2.json
    
## Development  [![CI](https://travis-ci.org/nodesphere/nodesphere.svg?branch=dev)](https://travis-ci.org/nodesphere/nodesphere)

### Starting a Local server

```
npm install
npm run serve
```

You should now be able to see an example at: <http://localhost:7000/example>

### In the browser

If you are creating a client side application using Nodesphere, consider using
polyfills to ensure maximum browser compatibility.
For example, include this line before all other javascript tags:

<script src="//cdn.polyfill.io/v1/polyfill.min.js"></script>

### Deploying to Heroku

The usual incantation should "just work":

```
heroku create && git push heroku master && heroku open
```

### Javascript Programmers

If you are more familiar with Javascript than Coffeescript,
you may like to continuously compile all Coffeescript to JS
to inspect the results of coffeescript source file changes:

```
npm run watch
```

Generated Javascript files are in `./lib/`.

