const WebSocket = require("ws");

const ws = new WebSocket("ws://localhost:3000");

let client = {
    "name":"choicef136",
    "data":{
      "positon":[0,0,0],
      "isshooting":true,
      "iscrouched":false
  }
};

ws.on("open", function open() {
    ws.send(JSON.stringify(client));
});
 
ws.on("message", function incoming(data) {
  console.log(data);
})