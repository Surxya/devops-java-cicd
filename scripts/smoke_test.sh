"#!/usr/bin/env bash
set -euo pipefail

URL=""${1:?usage: smoke_test.sh http://host:port}""

for i in $(seq 1 12); do
  code=$(curl -s -o /dev/null -w '%{http_code}' ""${URL}/health"" || true)
  if [ ""$code"" = ""200"" ]; then
    echo ""PASS: ${URL}/health returned 200""
    curl -s ""${URL}/hello?name=Jenkins""
    exit 0
  fi
  echo ""attempt ${i}/12: HTTP ${code} - retrying in 5s""
  sleep 5
done

echo ""FAIL: ${URL}/health did not return 200""
exit 1"
