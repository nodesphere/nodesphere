module.exports {
  # argument `obj` can be an oject with one level of key/values deep only.
  # values can be numeric, string, or array
  canocial_json: (obj) -> 
    pairs = for key in Object.keys(obj).sort()
      val = obj[key]
      if type(val) is 'object' 
        throw "Error: Object depth of one expected"
      else if type(val) is 'array'
        "#{JSON.stringify key}:#{JSON.stringify val.sort()}"
      else
        "#{JSON.stringify key}:#{JSON.stringify val}"
    "{#{pairs.join(',')}}"
}
