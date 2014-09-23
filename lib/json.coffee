{ type } = require 'lightsaber'

nodesphere_json = (data) -> 
  if type(data) is 'array'
    elements = for element in data
      nodesphere_json element
    '[' + elements.sort().join(',') + ']'
  else if type(data) is 'object' 
    key_val_pairs = for key in Object.keys(data).sort()
      val = data[key]
      "#{JSON.stringify key}:#{nodesphere_json val}"
    '{' + key_val_pairs.join(',') + '}'
  else
    JSON.stringify data

module.exports = { 
  nodesphere_json: nodesphere_json
  ns_json:         nodesphere_json
}
