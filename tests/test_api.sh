#!/bin/bash

# Usage: ./test_api.sh <TARGET_IP_VM1>
TARGET_IP=${1:-"192.168.1.10"}
PORT=3000

echo "--- VMware vSphere ICM Project: API Test ---"
echo "Testing connectivity to VM 1 at http://$TARGET_IP:$PORT..."

# 1. Ping the target host
ping -c 3 $TARGET_IP > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "[SUCCESS] Ping to VM 1 successful."
else
  echo "[FAILED] Ping to VM 1 failed. Check your VMware virtual networks!"
  exit 1
fi

# 2. Curl the API
echo "Querying RESTful API..."
RESPONSE=$(curl -s http://$TARGET_IP:$PORT/)

if [[ $RESPONSE == *"API Test Successful!"* ]]; then
  echo "[SUCCESS] Received valid API response from VM 1."
  echo "Response Data: $RESPONSE"
else
  echo "[FAILED] No response from API. Is 'node server.js' running on VM 1?"
fi
echo "-------------------------------------------"
