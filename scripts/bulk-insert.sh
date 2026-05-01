#!/bin/bash
# Bulk API 2.0 - Insert Account records using curl
set -e

API_VERSION="v66.0"
CSV_FILE="d:/sf-trail-mix/doc/bulkv2hocdata.csv"

# Get org credentials (sf org display returns exit code 1 due to warning, so || true)
ORG_INFO=$(sf org display --json 2>/dev/null || true)
ACCESS_TOKEN=$(echo "$ORG_INFO" | python -c "import sys,json; print(json.load(sys.stdin)['result']['accessToken'])")
INSTANCE_URL=$(echo "$ORG_INFO" | python -c "import sys,json; print(json.load(sys.stdin)['result']['instanceUrl'])")
BASE_URL="${INSTANCE_URL}/services/data/${API_VERSION}"

echo "Instance: $INSTANCE_URL"
echo ""

echo "=== Step 1: Create Bulk Ingest Job ==="
JOB_RESPONSE=$(curl -s \
  -X POST "${BASE_URL}/jobs/ingest" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"operation":"insert","object":"Account","contentType":"CSV","lineEnding":"LF"}')

JOB_ID=$(echo "$JOB_RESPONSE" | python -c "import sys,json; print(json.load(sys.stdin)['id'])")

if [ -z "$JOB_ID" ]; then
  echo "ERROR: Failed to create job"
  echo "$JOB_RESPONSE"
  exit 1
fi
echo "Job created: $JOB_ID"

echo ""
echo "=== Step 2: Upload CSV Data ==="
UPLOAD_RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X PUT "${BASE_URL}/jobs/ingest/${JOB_ID}/batches" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: text/csv" \
  --data-binary @"${CSV_FILE}")

HTTP_CODE=$(echo "$UPLOAD_RESPONSE" | tail -1)
echo "Upload HTTP status: $HTTP_CODE"

if [ "$HTTP_CODE" -lt 200 ] || [ "$HTTP_CODE" -ge 300 ]; then
  echo "ERROR: Upload failed"
  echo "$UPLOAD_RESPONSE"
  exit 1
fi
echo "CSV data uploaded successfully"

echo ""
echo "=== Step 3: Close Job (UploadComplete) ==="
curl -s \
  -X PATCH "${BASE_URL}/jobs/ingest/${JOB_ID}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{"state":"UploadComplete"}' > /dev/null
echo "Job closed for processing"

echo ""
echo "=== Step 4: Poll for Job Completion ==="
MAX_ATTEMPTS=30
ATTEMPT=0
STATE=""
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  ATTEMPT=$((ATTEMPT + 1))
  STATUS_RESPONSE=$(curl -s \
    -X GET "${BASE_URL}/jobs/ingest/${JOB_ID}" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}")

  STATE=$(echo "$STATUS_RESPONSE" | python -c "import sys,json; print(json.load(sys.stdin)['state'])")

  echo "  Attempt ${ATTEMPT}: state = ${STATE}"

  if [ "$STATE" = "JobComplete" ]; then
    RECORDS_PROCESSED=$(echo "$STATUS_RESPONSE" | python -c "import sys,json; print(json.load(sys.stdin)['numberRecordsProcessed'])")
    RECORDS_FAILED=$(echo "$STATUS_RESPONSE" | python -c "import sys,json; print(json.load(sys.stdin)['numberRecordsFailed'])")
    echo ""
    echo "=== Job Complete ==="
    echo "Records processed: $RECORDS_PROCESSED"
    echo "Records failed: $RECORDS_FAILED"
    break
  elif [ "$STATE" = "Failed" ] || [ "$STATE" = "Aborted" ]; then
    echo "ERROR: Job ended with state: $STATE"
    echo "$STATUS_RESPONSE"
    exit 1
  fi

  sleep 3
done

if [ "$STATE" != "JobComplete" ]; then
  echo "ERROR: Job did not complete in time"
  exit 1
fi

echo ""
echo "=== Step 5: Successful Results (first 20 lines) ==="
curl -s \
  -X GET "${BASE_URL}/jobs/ingest/${JOB_ID}/successfulResults" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" | head -20

echo ""
echo "=== Step 6: Failed Results ==="
curl -s \
  -X GET "${BASE_URL}/jobs/ingest/${JOB_ID}/failedResults" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" | head -20

echo ""
echo "=== DONE ==="
