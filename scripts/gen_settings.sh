"#!/usr/bin/env bash
set -euo pipefail

: ""${NEXUS_USER:?NEXUS_USER is not set}""
: ""${NEXUS_PASS:?NEXUS_PASS is not set}""

cat > settings-ci.xml <<EOF
<settings>
  <servers>
    <server>
      <id>nexus</id>
      <username>${NEXUS_USER}</username>
      <password>${NEXUS_PASS}</password>
    </server>
  </servers>
</settings>
EOF

chmod 600 settings-ci.xml
echo ""settings-ci.xml created"""
