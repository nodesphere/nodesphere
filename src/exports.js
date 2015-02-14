try {
  // this fails in webpack, but is not needed there
  // it is needed by Node.js
  require('coffee-script/register');
}
catch(e) {}

module.exports = require('./core/nodesphere.coffee');
