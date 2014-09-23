# Nodesphere

A nodesphere is a graph, in a simple JSON format, with content-addressable nodes and edges.

## Saving a Graph

### HTTP PUT request

For example, suppose you perform an HTTP `PUT`, with a json payload of nodes and edges:

    {
        "nodes": {
            "e9381b02": "John Perry Barlow",
            "85c3ef1e": "published",
            "b8925d6f": "A Declaration of Independence of Cyberspace"
        },
        "edges": {
            "dbfaa3ef": {
                "subject": "e9381b02",
                "predicate": "85c3ef1e",
                "object": "b8925d6f"
            }
        }
    }

The ID of each node can be any unique string.  In this case we use the hash of the node's sorted minified JSON.  For example:

    e9381b02

is the hash of

    'John Perry Barlow'

And:

    dbfaa3ef

is the hash of

    '{"object":"b8925d6f","predicate":"85c3ef1e","subject":"e9381b02"}'

Note that the JSON is minified and sorted by keys.


### HTTP PUT response

The expected response to the `PUT` request is one or more keys:

    {
        "sha384": "490c56e9"
    }

Where `490c56e9` is the hash of the JSON of the entire "packed" sphere:

    '{"edges":["dbfaa3ef"],"nodes":["85c3ef1e","b8925d6f","e9381b02"]}'

Note that the array values are sorted, as well as the object keys.

