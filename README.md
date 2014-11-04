# Nodesphere

Nodesphere is an interchange format for node networks. It has three primary objectives:

1. Create interoperability among graph visualization interfaces
2. Provide adaptors to connect these interfaces to personal data ecosystems,
including social network data, online drives, and ultimately, any public or private data
3. Abstract data storage and retrieval, allowing transitions
from traditional server & database systems toward secure, distributed public and private storage,
as these systems become practical and performant

## Philosophical

Everything we want to share is a graph, or more colloquially, a group of knowledge nodes; a sphere of nodes; a nodesphere.
Nodesphere is designed to help enable the curation, sharing, visualization, and navigation of all your graph data!

## Technical

Let's get down to the bare metal. A nodesphere is a graph, in a simple JSON format, with content-addressable nodes and edges.
The JSON has a deterministic order so that content addresses are always consistent:

- Arrays of content IDs are sorted
- Objects are sorted by their keys

## Development

### Starting a Local server

```
npm install
npm start
```

### Deploying to Heroku

```
heroku create
git push heroku master
heroku open
```

### Coffeescript

If you are more familiar with Javascript than Coffeescript,
you may like to continuously compile all Coffeescript to JS:

```
bin/watch-coffee
```

Generated Javascript files are in subdirs of `./tmp/js/`.
Note that these are for training purposes only and are not used by the application.

