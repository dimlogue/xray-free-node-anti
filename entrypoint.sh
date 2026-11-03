#!/bin/sh
# Entrypoint: builds xray config from env vars at container start.
# Required env: UUID (VLESS client id). Optional: WS_PATH (default /tk-xray), PORT (default 8080).
set -eu
: "${UUID:?need UUID env}"
WS_PATH="${WS_PATH:-/tk-xray}"
PORT="${PORT:-8080}"
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [{ "id": "${UUID}" }],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "${WS_PATH}" }
      }
    }
  ],
  "outbounds": [{ "protocol": "freedom", "tag": "direct" }]
}
EOF
exec /usr/local/bin/xray run -config /etc/xray/config.json
