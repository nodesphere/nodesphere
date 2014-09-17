# Nodesphere

A nodesphere is a graph, in a simple JSON format, with content-addressable nodes and edges.

## Saving a Graph

### HTTP PUT request

For example, suppose you perform an HTTP `PUT`, with a json payload of nodes and edges:

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

The ID of each node can be any unique string.  In this case we use the hash of the node's sorted minified JSON.  For example:

    7db403b1

is the hash of

    '{"content":"John Perry Barlow"}'

And:

    1068b6e0

is the hash of

    '{"object":"015db549","predicate":"0ae5fb5c","subject":"7db403b1"}'

Note that the JSON is minified and sorted by keys.


### HTTP PUT response

The expected response to the `PUT` request is one or more keys:

    {
        "sha384": "5923e083"
    }

Where, for example, `5923e083` is the hash of the JSON of the entire "packed" sphere:

    '{"edges":["1068b6e0"],"nodes":["015db549","0ae5fb5c","7db403b1"]}'

Note that the array values are sorted, as well as the object keys.

