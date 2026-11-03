# xray-free-node

Minimal xray (VLESS + WebSocket) container for free container platforms.
TLS is terminated by the platform's own HTTPS edge; xray itself serves
plain VLESS-over-WebSocket on `$PORT`.

Env vars (set in the platform dashboard, never baked into the image):

- `UUID` — VLESS client id (required)
- `WS_PATH` — websocket path (default `/tk-xray`)
- `PORT` — listen port (default `8080`; most platforms inject this)
