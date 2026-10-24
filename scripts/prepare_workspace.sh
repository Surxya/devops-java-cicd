"#!/usr/bin/env bash
set -euo pipefail

echo ""=== Preparing workspace ===""
rm -rf target reports
mkdir -p reports

BUILD_TS=$(date -u +%Y%m%dT%H%M%SZ)
GIT_SHA=$(git rev-parse --short HEAD)

cat > build.env <<EOF
BUILD_TS=${BUILD_TS}
GIT_SHA=${GIT_SHA}
EOF

echo ""--- build.env ---""; cat build.env
echo ""--- environment ---""
java -version 2>&1 | head -1
df -h . | tail -1"
