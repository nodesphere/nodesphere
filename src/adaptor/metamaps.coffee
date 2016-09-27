{ d, pjson } = require 'lightsaber/lib/log'
Promise = require 'bluebird'
axios = require 'axios'

Sphere = require '../core/sphere'

class MetamapsAdaptor

  @create: -> Promise.resolve new MetamapsAdaptor

  fetch: ({protocol, domain, mapId}) ->
    protocol ?= 'https://'
    canonicalUrl = "#{protocol}#{domain}/api/v2/maps/#{mapId}?embed=topics,synapses"
    axios.get canonicalUrl
    .then (response) ->
      {topics, synapses} = response.data.data
      sphere = new Sphere id: canonicalUrl
      for topic in topics
        sphere.addNode topic
      for synapse in synapses
        sphere.addEdge
          start: sphere.nodes[synapse.node1_id]
          end: sphere.nodes[synapse.node2_id]
      sphere

module.exports = MetamapsAdaptor
