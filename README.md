# Nodesphere

Nodesphere is an interchange format for node networks. It has three primary objectives:

1. Create interoperability among graph visualization interfaces
2. Provide adaptors to connect these interfaces to personal data ecosystems,
including social network data, online drives, and ultimately, any public or private data
3. Abstract data storage and retrieval, allowing transitions
from traditional server & database systems toward secure, distributed public and private storage,
as these systems become practical and performant

## Philosophical

Everything we want to share is a graph, or more colloquially, a group of knowledge nodes; a sphere of nodes; a nodeshpere.
Nodesphere is designed to help enable the curation, sharing, visualization, and navigation of all your graph data!

## Technical

Let's get down to the bare metal. A nodesphere is a graph, in a simple JSON format, with content-addressable nodes and edges.
The JSON has a deterministic order so that content addresses are always consistent:

- Arrays of content IDs are sorted
- Key-value "objects" are sorted by their keys

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


## Development

### Starting a Local server

```
npm install
npm start
```

### Coffeescript

If you are more familiar with Javascript than Coffeescript,
you may like to continuously compile all Coffeescript to JS:

```
bin/watch-coffee
```

Generated Javascript files are in subdirs of `./tmp/js/`.
Note that these are for training purposes only and are not used by the application.

