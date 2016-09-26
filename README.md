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

## Content Nodes

Nodes are canonically expressed in JSON.

A node may contain its content directly in the `data` field:

```js
{
  "id": "QmNusqXRpBzVzTjXjXX1hJyiNpfyRzKSNpEDDDpU1niYna",  // hash of data
  "data": "\n                    THE CLUETRAIN MANIFESTO\n                    http://www.cluetrain.com\n\n\n..."
}
```

The `data` field can also be any valid JSON data structure:

```js
{
  "id": "QmVfkFMFgL24Xfpna6yGVUTmGNXE3oYVnKy1Ymmt3UQumf",  // hash of canonical JSON of data
  "data": {
    "name": "Jane Doe",
    "jobTitle": "Professor",
    "telephone": "(555) 123-4567",
    "url": "http://www.example.com"
  }
}
```

A node may also refer to content in a mutable external resource by URL:

```js
{
  "id": "http://www.cluetrain.com/cluetrain.pdf"
}
```

A node may also refer to content in an immutable external resource by content address:

```js
{
  "id": "QmUbcmbrw5XaEXLhdKbWMbF2kChkxnaCqpLMgryUMeQgzR"  // hash of resource
}
```

## Edges

An "edge" ties together a relationship between two nodes, eg:

```js
{
  "id": "QmbnrrcA7Gvo8um4AfzAZV8u8UXgWsmA1S1HU8gR2TZAam",  // hash of canonical JSON of data
  "data": {
    "type": "edge",
    "start": "QmUbcmbrw5XaEXLhdKbWMbF2kChkxnaCqpLMgryUMeQgzR",  // A Declaration of the Independence of Cyberspace
    "content": "by",
    "end": "https://homes.eff.org/~barlow/"  // John Perry Barlow
  }
}
```

## Nodesphere

A nodesphere is a graph, with nodes, edges, and metadata.  An "expanded" nodesphere:

```js
{
  "id": "QmZMdjuPHTvAQo88ZzAb1EyJPjxaghucCW6YHpf7Lr2Y2p",  // hash of canonical JSON of data
  "data": {
    "type": "sphere",
    "name": "Manifestos"
    "nodes": [
      {
        "id": "QmSrSwSDfQhgh6ees1VbMRiQG64ixH12Xv1hoQYUFH77E7",  // hash of canonical JSON of data
        "data": {
          "name": "John Perry Barlow",
          "jobTitle": "Cyberlibertarian",
          "telephone": "800/654-4322",
          "url": "https://homes.eff.org/~barlow/"
        }
      }
    ]
    "edges": [
      {
        "id": "QmbnrrcA7Gvo8um4AfzAZV8u8UXgWsmA1S1HU8gR2TZAam",  // hash of canonical JSON of data
        "data": {
          "type": "edge",
          "start": "QmVDWmkM87NfR85WE1LvfwfJLRcMEtfNnCBiCJQRePP7Ly",  // A Declaration of the Independence of Cyberspace
          "content": "by",
          "end": "QmSrSwSDfQhgh6ees1VbMRiQG64ixH12Xv1hoQYUFH77E7"  // John Perry Barlow
        }
      }
    ]
  }
}
```

The same nodesphere in "compacted" format, which assumes that the
referenced nodes and edges are retrievable in their expanded form
by their content addresses:

```js
{
  "id": "QmZMdjuPHTvAQo88ZzAb1EyJPjxaghucCW6YHpf7Lr2Y2p",  // hash of canonical JSON of data
  "data": {
    "type": "sphere",
    "name": "Manifestos"
    "nodes": [
      "QmVDWmkM87NfR85WE1LvfwfJLRcMEtfNnCBiCJQRePP7Ly",
      "QmSrSwSDfQhgh6ees1VbMRiQG64ixH12Xv1hoQYUFH77E7"
    ]
    "edges": [
      "QmbnrrcA7Gvo8um4AfzAZV8u8UXgWsmA1S1HU8gR2TZAam"
    ]
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
