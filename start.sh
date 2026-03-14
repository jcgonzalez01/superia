#!/bin/sh
echo "Starting Node proxy on :3001..."
node /app/proxy.js &
echo "Starting Nginx on :80..."
nginx -g "daemon off;"
