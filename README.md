# Nodesphere

[![Build Status](https://travis-ci.org/nodesphere/nodesphere.svg)](https://travis-ci.org/nodesphere/nodesphere)

> Note: Nodesphere is currently pre-alpha, and things are likely to change. We don't recommend you use it in production yet.

## Objectives

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

## Semantic Crunching

Nodesphere uses semantic crunching technology, which reduces data inputs into their atomic semantic nodes. Regardless of the data source, the important knowledge is digested into an interconnected graph, with appropriate connections between tags, categories, peoples' names, etc.

## Project Genesis

Nodesphere comes from [Enlightened Structure](http://www.enlightenedstructure.net/#/) and [Superluminal ⨕ Systems](http://superluminal.is/).

Nodesphere is being developed primarily in the context of the [Core Network](https://github.com/core-network/core-network) project.

## Development  

### Architectural Notes

- Both Nodes and Edges are implemented as _maps_, or sets of key-value pairs.
- Edges have the special keys `start` and `end` which point to those respective nodes.

### In the browser

If you are creating a client side application using Nodesphere, consider using
polyfills to ensure maximum browser compatibility.
For example, include this line before all other javascript tags:

<script src="//cdn.polyfill.io/v1/polyfill.min.js"></script>

We build with browserify.  Webpack or similar should work fine too.

### IPFS

In order to for the IPFS adaptor to run from client side code served by IPFS itself, you need to configure CORS support in IPFS, eg `ipfs config edit` and then add something like:

```json
"HTTPHeaders": {
  "Access-Control-Allow-Methods": [
    "GET"
  ],
  "Access-Control-Allow-Origin": [
    "http://localhost:8080"
  ]
}
```
