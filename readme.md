# Overview
A simple facebook library for node.js.  Uses fibers to keep things
sane.

# Use
```javascript
var fb = require('fibered-facebook')
var json fb.graph('token').get('/me')
console.log("I have some json: " + json.data);
```
