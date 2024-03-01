#!/usr/bin/env sh

if [ -z "$PORT" ]; then
  PORT=3000
fi
export PORT

TIGERBEETLE=/usr/src/tigerbeetle/tigerbeetle

if [ ! -f /data/0_0.tigerbeetle ]; then
  echo "[*] Setting up tigerbeetle database..."
  $TIGERBEETLE format --cluster=0 --replica=0 --replica-count=1 /data/0_0.tigerbeetle
fi

echo "[*] Starting tigerbeetle on port $PORT..."
exec $TIGERBEETLE start --addresses=0.0.0.0:$PORT  /data/0_0.tigerbeetle 

# --cache-grid=16MB
