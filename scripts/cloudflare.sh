#!/data/data/com.termux/files/usr/bin/bash

PORT=${CLOUDFLARE_PORT:-3000}
LOG_FILE=${CLOUDFLARE_LOG:-cloudflared.log}

echo "☁ Starting Cloudflare Tunnel on port $PORT"

cloudflared tunnel \
  --no-autoupdate \
  --logfile "$LOG_FILE" \
  --loglevel info \
  --url http://localhost:$PORT
