const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 3000;
const STATIC_DIR = path.join(__dirname, 'public');

const MIME = {
  '.html': 'text/html',
  '.js':   'application/javascript',
  '.json': 'application/json',
  '.png':  'image/png',
  '.ico':  'image/x-icon',
  '.css':  'text/css',
};

function serveStatic(res, filePath) {
  fs.readFile(filePath, (err, data) => {
    if (err) { res.writeHead(404); res.end('Not found'); return; }
    const ext = path.extname(filePath);
    res.writeHead(200, { 'Content-Type': MIME[ext] || 'application/octet-stream' });
    res.end(data);
  });
}

function proxyAnthropic(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, x-api-key, anthropic-version');

  if (req.method === 'OPTIONS') { res.writeHead(204); res.end(); return; }

  let body = '';
  req.on('data', c => body += c);
  req.on('end', () => {
    const opts = {
      hostname: 'api.anthropic.com',
      path: '/v1/messages',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': req.headers['x-api-key'] || '',
        'anthropic-version': req.headers['anthropic-version'] || '2023-06-01',
        'Content-Length': Buffer.byteLength(body)
      }
    };
    const pr = https.request(opts, r => {
      res.writeHead(r.statusCode, { 'Content-Type': 'application/json' });
      r.pipe(res);
    });
    pr.on('error', e => { res.writeHead(502); res.end(JSON.stringify({error: e.message})); });
    pr.write(body);
    pr.end();
  });
}

const server = http.createServer((req, res) => {
  const url = req.url.split('?')[0];

  if (url === '/proxy/v1/messages') {
    proxyAnthropic(req, res);
    return;
  }

  // Static files
  let filePath = path.join(STATIC_DIR, url === '/' ? 'index.html' : url);
  // Prevent path traversal
  if (!filePath.startsWith(STATIC_DIR)) { res.writeHead(403); res.end(); return; }

  fs.stat(filePath, (err, stat) => {
    if (err || !stat.isFile()) {
      // SPA fallback
      serveStatic(res, path.join(STATIC_DIR, 'index.html'));
    } else {
      serveStatic(res, filePath);
    }
  });
});

server.listen(PORT, () => console.log(`PreciosRD server on :${PORT}`));
