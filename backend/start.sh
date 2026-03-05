#!/bin/bash
set -e

echo "=== Creating KMS key in LocalStack ==="

# Wait for LocalStack to be ready
for i in $(seq 1 30); do
    if curl -s "$COMMON_AWS_ENDPOINT_URL/_localstack/health" | grep -q '"kms"'; then
        echo "LocalStack KMS is ready"
        break
    fi
    echo "Waiting for LocalStack... attempt $i"
    sleep 2
done

# Create the KMS key with the specific key ID we need
KEY_ID="00000000-0000-0000-0000-000000000001"

# Check if key already exists, create if not
aws --endpoint-url="$COMMON_AWS_ENDPOINT_URL" \
    --region "$COMMON_AWS_REGION" \
    kms describe-key --key-id "$COMMON_KEY_ENCRYPTION_KEY_ARN" 2>/dev/null || \
aws --endpoint-url="$COMMON_AWS_ENDPOINT_URL" \
    --region "$COMMON_AWS_REGION" \
    kms create-key \
    --description "ACI encryption key" \
    --key-usage ENCRYPT_DECRYPT \
    --origin AWS_KMS 2>/dev/null || true

echo "=== Starting uvicorn ==="
exec uvicorn aci.server.main:app --host 0.0.0.0 --port "$PORT"
