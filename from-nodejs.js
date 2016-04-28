#!/usr/bin/env node

d = require('lightsaber/lib/log').d

Nodesphere = require('..')
Metamaps = Nodesphere.adaptor.Metamaps
Ipfs = Nodesphere.adaptor.Ipfs

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


// metamaps.fetch({protocol, domain, mapId})
// .then (function(source) {
//   this.source = source
//   console.log('Retrieved data for:')
//   console.log(source.id)
//   // return Ipfs.create({protocol: 'http', host: 'v03x.ipfs.io', port: 80})
//   return Ipfs.create()
// }).then(function(target) {
//   return target.put({
//     content: this.source.toJson()
//   })
// }).then(function(ipfsHashes) {
//   // console.log(ipfsHashes)
//   console.log("https://ipfs.io/ipfs/" + ipfsHashes[0])
// // }).error(function(error) {
// //   throw error
// //   // console.error(error.stack);
// }).catch(function(error) {
//   console.error(error.stack);
//   // throw error
//   // console.error(error.stack);
// })
