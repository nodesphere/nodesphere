{ log, p, similar } = require 'lightsaber'

Node = require '../core/node'
Nodesphere = require '../core/nodesphere'

class Algebra
  @multiply: (content_sphere, filter_sphere) ->
    product = new Nodesphere()
    for content_node in content_sphere.nodes()
      product_node = new Node()
      content_names = content_node.get_keys()
      if content_names
        product_node.add_keys content_names
        product.add_node product_node
        for content_key, content_weight of content_node.weights()
          for filter_node in filter_sphere.nodes()
            filter_names = filter_node.get_keys()
            if filter_names
              for filter_key, filter_weight of filter_node.weights()
                if similar content_key, filter_key
                  for filter_name in filter_names
                    weight = content_weight * filter_weight
                    if weight > 0
                      product_node.increment filter_name, weight
#                      log "#{content_key} [#{filter_name}]"
    product

module.exports = Algebra
