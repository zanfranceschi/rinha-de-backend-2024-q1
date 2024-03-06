## shinsei (新生)
> Shinsei is a (Proxy Server with Load Balancing) project created in Go, and means "rebirth" or "new life" (新生).

This is a simple proxy server with load balancing capability implemented in Go. It uses the Round Robin algorithm to evenly distribute requests among available backend servers.

## Features

- **Round Robin Load Balancer**: Distributes requests in a circular manner among backend servers.
- **Proxy Handler**: Manages incoming requests, forwards them to the selected server, and relays responses back to the client.
- **Custom HTTP Client**: Utilizes a customized HTTP client for making requests to backend servers.
- **Request Listening**: Listens for HTTP requests and forwards them to backend servers.
- **Error Handling**: Manages errors during request forwarding and returns a "Bad Gateway" status code if an error occurs.
