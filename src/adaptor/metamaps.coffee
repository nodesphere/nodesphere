{ d, pjson } = require 'lightsaber/lib/log'
Promise = require 'bluebird'
axios = require 'axios'

Sphere = require '../core/sphere'

class MetamapsAdaptor

  @create: (args) ->
    Promise.resolve new MetamapsAdaptor args

  fetch: ({protocol, domain, mapId}) ->
    protocol ?= 'https://'
    canonicalUrl = "#{protocol}#{domain}/api/v1/maps/#{mapId}"
    corsHackUrl =  "#{protocol}cors-anywhere.herokuapp.com/#{domain}/api/v1/maps/#{mapId}"
    axios.get corsHackUrl, headers: {'X-Requested-With': 'XMLHttpRequest'}
    .then (response) ->
      topics = {}
      sphere = new Sphere id: canonicalUrl
      for topic in response.data.topics
        sphere.addNode topic
      for synapse in response.data.synapses
        sphere.addEdge
          start: sphere.nodes[synapse.topic1_id]
          end: sphere.nodes[synapse.topic2_id]
      sphere

module.exports = MetamapsAdaptor
