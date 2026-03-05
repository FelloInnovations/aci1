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
KEY_ID=$(aws --endpoint-url=$COMMON_AWS_ENDPOINT_URL kms create-key \
  --region us-east-2 \
  --description "ACI encryption key" \
  --query 'KeyMetadata.KeyId' \
  --output text 2>/dev/null)

if [ -z "$KEY_ID" ]; then
  echo "Key creation failed or already exists, trying to find existing key..."
  KEY_ID=$(aws --endpoint-url=$COMMON_AWS_ENDPOINT_URL kms list-keys \
    --region us-east-2 \
    --query 'Keys[0].KeyId' \
    --output text)
fi

echo "Using KMS Key ID: $KEY_ID"
export COMMON_KEY_ENCRYPTION_KEY_ARN="arn:aws:kms:us-east-2:000000000000:key/$KEY_ID"
echo "KMS ARN set to: $COMMON_KEY_ENCRYPTION_KEY_ARN"

echo "Finding alembic..."
find / -name "alembic" -type f 2>/dev/null

echo "Starting server..."
uvicorn aci.server.main:app \
  --proxy-headers \
  --forwarded-allow-ips=* \
  --host 0.0.0.0 \
  --port $PORT \
  --no-access-log
