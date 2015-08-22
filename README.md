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

## Development  

### In the browser

If you are creating a client side application using Nodesphere, consider using
polyfills to ensure maximum browser compatibility.
For example, include this line before all other javascript tags:

<script src="//cdn.polyfill.io/v1/polyfill.min.js"></script>

We build with browserify.  Webpack or similar should work fine too.

## Notes

- Both Nodes and Edges are implemented as _maps_, or sets of key-value pairs.
- Edges have the special keys `start` and `end` which point to those respective nodes.
