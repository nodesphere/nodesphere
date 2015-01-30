# Nodesphere

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
- Nodes are composed of attributes
- Each attribute has a unique key (a string)
- Each attribute can have multiple values (of type string, number, boolean or null)
- Values must be unique, but only within the scope of that attribute

An example of a Node:

    {
      "name": [
        "Venus"
      ],
      "Archetype": [
        "lover",
        "artist"
      ],
      "_id": [
        "SPnxgs4j9BDcLVJEZXvASxhi2NukZAPTT6iXwbZrG2MtohJtPcC1boLbL7zeXVJcevYSfZL76xfpsHH8Qi1pzCfM"
      ],
    }
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

A nodesphere is a collection of nodes, each of which may have any number of attributes.

For example:

    {
      "_name": [
        "Planetary forces"
      ],
      "Venus": [
        "SPnxgs4j9BDcLVJEZXvASxhi2NukZAPTT6iXwbZrG2MtohJtPcC1boLbL7zeXVJcevYSfZL76xfpsHH8Qi1pzCfM"
      ],
      "Jupiter": [
        "PwrofMF6WVXyFsRYHZWYdyzo2wnQVALB4B3V8AKZxkdZb8mA93KFLAFF5uyTuwfNYiQJZuc6qQzp7sb18ws5hAmM"
      ],
      "_id": [
        "XaAbGQUB6t4DdysVCYCAmpN7RTXUXWac1sPzyz8nGgiiR3wsDc2AAQT71u4sBAo3H8iWWBb8VhtSWPGvxKyrqSFE"
      ]
    }
## Graph Modeling

Every _nodesphere_ is modeled as a directed multigraph (multidigraph),
also known as a [quiver](https://en.wikipedia.org/wiki/Quiver_%28mathematics%29) -- that is, a directed graph allowing for multiple edges which share the same vertices.

Each _node_ is modeled as a [vertex](https://en.wikipedia.org/wiki/Vertex_%28graph_theory%29), where the label on the vertex is the _ID_ of the _node_.  (Note that we speak only of graph vertices, never "graph nodes", to avoid confusion with nodesphere's concept of a node.)

Each _attribute_ is modeled as an [arc (directed edge)](https://en.wikipedia.org/wiki/Glossary_of_graph_theory#Direction), which has a tail (the vertex of the _node_), a label (the attribute name), and a head (the vertex of the attribute value).

Both the _vertices_ and the _arcs_ are [labeled](https://en.wikipedia.org/wiki/Graph_labeling), where the labels are the graph data itself.

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
bin/watch-coffee
```

Generated Javascript files are in subdirs of `./tmp/js/`.
Note that these are for learning purposes only and are not used by the application.

