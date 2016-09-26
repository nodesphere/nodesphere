#!/usr/bin/env node

nodesphere = require('..')

nodesphere.adaptor.Ipfs.create({protocol: 'http', host: 'ipfs.io', port: 80})
.then((ipfs) => {
  return ipfs.fetch({rootNodeId: 'QmavE42xtK1VovJFVTVkCR5Jdf761QWtxmvak9Zx718TVr'})
}).then((sphere) => {
  console.log(sphere.data())
}).catch(function(error) {
  console.error(error.stack);
})
