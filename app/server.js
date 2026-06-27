const http = require("http");
const PORT = process.env.PORT || 8080;

const server = http.createServer((req, res) => {
  // Health check — Kubernetes hits this to confirm the pod is alive.
  if (req.url === "/health") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ status: "healthy" }));
    return;
  }
  // Main page with your custom message.
  res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  res.end(`<h1>CloudScale is running 🚀</h1>
           <p>Deployed by Ahmad El-Mufti, Aya Abuoud,and Siraj ElFaitouri</p>
           <p>Served by pod: ${process.env.HOSTNAME || "local"}</p>`);
});

server.listen(PORT, () => console.log(`CloudScale app on port ${PORT}`));