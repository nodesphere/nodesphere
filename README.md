# Nodesphere

Everything we want to share is a graph, which can be seen as a group of knowledge nodes.
We think of this as a "sphere" of nodes; thus _nodesphere_.
Nodesphere is designed to help enable the curation, sharing, visualization, and navigation of all your graph data.

## Objectives

Nodesphere is an interchange format for node networks. It has three primary objectives:

1. Create interoperability among graph visualization interfaces
2. Provide adaptors to connect these interfaces to personal data ecosystems,
including social network data, online drives, and ultimately, any public or private data
3. Abstract data storage and retrieval, allowing transitions
from traditional server & database systems toward secure, distributed public and private storage,
as these systems become practical and performant

## Format

A nodesphere is a graph, with nodes, edges, and metadata.  A simple example nodesphere:

```js
{
  "nodes": [
    {
      "id": "/ipfs/QmVDWmkM87NfR85WE1LvfwfJLRcMEtfNnCBiCJQRePP7Ly",
      "name": "A Declaration of the Independence of Cyberspace"
    },
    {
      "id": "https://homes.eff.org/~barlow/",
      "name": "John Perry Barlow"
    }
  ],
  "edges": [
    {
      "id": "QmbnrrcA7Gvo8um4AfzAZV8u8UXgWsmA1S1HU8gR2TZAam",  // multihash of canonical json of data
      "data": {
        "start": "/ipfs/QmVDWmkM87NfR85WE1LvfwfJLRcMEtfNnCBiCJQRePP7Ly",
        "end": "https://homes.eff.org/~barlow/",
        "content": "by"
      }
    }
  ],
  "metatdata": {
    "name": "Manifestos"
  }
}
```

## Examples

### IPFS (InterPlanetary File System)

```javascript
const nodesphere = require('nodesphere')

nodesphere.adaptor.Ipfs.create({protocol: 'http', host: 'ipfs.io', port: 80})
.then((ipfs) => {
  return ipfs.fetch({rootNodeId: 'QmavE42xtK1VovJFVTVkCR5Jdf761QWtxmvak9Zx718TVr'})
}).then((sphere) => {
  console.log(sphere.data())
})

// prints something like:
// {
//   nodes: {
//     QmavE42xtK1VovJFVTVkCR5Jdf761QWtxmvak9Zx718TVr: {},
//     QmeJTXoV3NeYjScPNAbzk81z9qa7kgb91AnxTgQicpGQXs: { name: '2010', size: 46656, ipfsType: 1 },
//     QmYg9SGT2qBu8BL7NbbT3Wzh1CXyJVGSMFuRLPcLquRhmX: { name: 'index.html', size: 134539, ipfsType: 2 },
//     ...
//   },
//   edges: {
//     'QmavE42xtK1VovJFVTVkCR5Jdf761QWtxmvak9Zx718TVr -> QmeJTXoV3NeYjScPNAbzk81z9qa7kgb91AnxTgQicpGQXs': { start: [Object], end: [Object] },
//     'QmavE42xtK1VovJFVTVkCR5Jdf761QWtxmvak9Zx718TVr -> QmYg9SGT2qBu8BL7NbbT3Wzh1CXyJVGSMFuRLPcLquRhmX': { start: [Object], end: [Object] },
//     ...
//   }
// }
```

### Other Examples

For examples of usage in both Node.js and browser, see: https://github.com/nodesphere/nodesphere/tree/master/examples

You can also see examples running live in the browser:

- http://nodesphere.github.io/nodesphere/ipfs.html
- http://nodesphere.github.io/nodesphere/gsheet.html
- http://nodesphere.github.io/nodesphere/gdrive.html
- http://nodesphere.github.io/nodesphere/metamaps.html

These are intentionally written in simple JS directly in the page source.

## Project Genesis

Nodesphere comes from [Enlightened Structure](http://www.enlightenedstructure.net/#/) and [Superluminal ⨕ Systems](http://superluminal.is/).

Nodesphere is being developed primarily in the context of the [Core Network](https://github.com/core-network/core-network) project.

## Development

[![Build Status](https://travis-ci.org/nodesphere/nodesphere.svg?branch=master)](https://travis-ci.org/nodesphere/nodesphere)

> Nodesphere is currently pre-alpha, and things are likely to change. We don't recommend you use it in production yet.
>
> Nodesphere had a complete rewrite on a fresh branch with a new history as of v0.4.0.  The older version can be found on the [0.3.x](https://github.com/nodesphere/nodesphere/tree/0.3.x) tree.

### In the browser

If you are creating a client side application using Nodesphere, consider using
polyfills to ensure maximum browser compatibility.
For example, include this line before all other javascript tags:

<script src="//cdn.polyfill.io/v1/polyfill.min.js"></script>

We build with Webpack.  Browserify or similar should work fine too.
