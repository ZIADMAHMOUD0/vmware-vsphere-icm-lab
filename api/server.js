const http = require('http');
const port = 3000;

const server = http.createServer((req, res) => {
  if (req.method === 'GET' && req.url === '/') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      message: "VMware vSphere ICM Project: API Test Successful!",
      host: "VM 1 (on ESXi Host 1)",
      status: "Online",
      timestamp: new Date().toISOString()
    }));
  } else if (req.method === 'GET' && req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('API is healthy and reachable from the network.');
  } else {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Not Found');
  }
});

server.listen(port, '0.0.0.0', () => {
  console.log(`ICM API listening at http://0.0.0.0:${port}`);
 });
