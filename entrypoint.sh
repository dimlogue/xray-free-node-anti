#!/bin/sh
# Entrypoint: builds xray config from env vars at container start.
# Required env: UUID (VLESS client id). Optional: WS_PATH (default /tk-xray), PORT (default 8080).
set -eu
: "${UUID:?need UUID env}"
WS_PATH="${WS_PATH:-/tk-xray}"
PORT="${PORT:-8080}"
mkdir -p /etc/xray /var/log/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "info", "access": "/var/log/xray/access.log" },
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
# ship xray access log to container stdout so it shows in platform logs
touch /var/log/xray/access.log
tail -n 0 -f /var/log/xray/access.log &
exec /usr/local/bin/xray run -config /etc/xray/config.json
