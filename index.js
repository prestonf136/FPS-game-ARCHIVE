const r = require("rethinkdb");
const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 3000 });
 
var connd = null;
r.connect( {host: 'localhost', port: 28015}, function(err, conn) {
    if (err) throw err;
    connd = conn;
});


wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    msgjson = JSON.parse(message)
    r.db("Shooter").table("MATCHID_1").insert(msgjson).run(connd)
    console.log('received: %s', message);
  });
  positions = r.db("Shooter").table("MATCHID_1").filter(JSON.parse(`{"id": "e90bb47a-c3d0-4fba-ad04-4970d6f4e41f"}`)).run(connd)
  console.log(positions)
  console.log("test")
  positions = JSON.stringify(positions)
  console.log(positions)
  ws.send(positions);
});