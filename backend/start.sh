#!/bin/bash
set -e

echo "Waiting for LocalStack..."
for i in $(seq 1 30); do
  if aws --endpoint-url=$COMMON_AWS_ENDPOINT_URL kms list-keys --region us-east-2 > /dev/null 2>&1; then
    echo "LocalStack is ready."
    break
  fi
  echo "Attempt $i/30..."
  sleep 2
done

echo "Creating KMS key..."
aws --endpoint-url=$COMMON_AWS_ENDPOINT_URL kms create-key \
  --region us-east-2 \
  --key-id 00000000-0000-0000-0000-000000000001 \
  --description "ACI encryption key" 2>/dev/null || echo "Key may already exist, continuing..."

echo "Starting server..."
uvicorn aci.server.main:app \
  --proxy-headers \
  --forwarded-allow-ips=* \
  --host 0.0.0.0 \
  --port $PORT \
  --no-access-log
