# NodeSphere

Simple GET and PUT operations for _nodespheres_, which are simply graphs: collections of nodes and links.

## PUT

### The PUT request

For example, suppose you perform an HTTP `PUT`, with a json payload of nodes and links:

    {
        "nodes": {
            "7db403b1": {
                "content": "John Perry Barlow"
            },
            "0ae5fb5c": {
                "content": "published"
            },
            "015db549": {
                "content": "A Declaration of Independence of Cyberspace"
            }
        },
        "edges": {
            "1068b6e0": {
                "subject": "7db403b1",
                "predicate": "0ae5fb5c",
                "object": "015db549"
            }
        }
    }

The ID of each node can be any unique string.  In this case we use the SHA-384 of the node's sorted minified JSON.  For example:

    7db403b1

is the SHA-384 of

    '{"content":"John Perry Barlow"}'

And:

    1068b6e0

is the SHA-384 of

    '{"object":"015db549","predicate":"0ae5fb5c","subject":"7db403b1"}'

Note that the JSON is minified and sorted by keys.


### The PUT response

The expected response to the `PUT` request is one or more keys:

{
    "sha384": "5923e083"
}

Where, for example, `5923e083` is the SHA-384 of the JSON of the entire "packed" sphere:

    '{"edges":["1068b6e0"],"nodes":["015db549","0ae5fb5c","7db403b1"]}'

Note that the array values are sorted, as well as the object keys.

