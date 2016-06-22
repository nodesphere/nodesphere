#!/usr/bin/env node

d = require('lightsaber/lib/log').d

Nodesphere = require('..')
Metamaps = Nodesphere.adaptor.Metamaps

protocol = 'https://'
domain = 'metamaps.herokuapp.com'
mapId = 3
url = protocol + domain + '/maps/' + mapId

metamaps = new Metamaps()

console.log('Fetching Metamap from ' + url + ' ...')

return Ipfs.create()
.then(function(ipfs) {
  return ipfs.fetch({rootNodeId: 'QmavE42xtK1VovJFVTVkCR5Jdf761QWtxmvak9Zx718TVr'})
}).then(function(sphere) {
  d(sphere)
}).catch(function(error) {
  console.error(error.stack);
})
