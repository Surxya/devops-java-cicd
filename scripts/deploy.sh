"#!/usr/bin/env bash
set -euo pipefail

: ""${EC2_HOST:?EC2_HOST is not set}""
WAR=""target/devops-demo.war""
SSH_OPTS=""-o StrictHostKeyChecking=accept-new -o ConnectTimeout=15""

[ -f ""$WAR"" ] || { echo ""ERROR: $WAR not found""; exit 1; }

echo ""Uploading $WAR to ${EC2_HOST} ...""
scp ${SSH_OPTS} ""$WAR"" ""ubuntu@${EC2_HOST}:/tmp/ROOT.war""
ssh ${SSH_OPTS} ""ubuntu@${EC2_HOST}"" ""mv /tmp/ROOT.war /opt/tomcat/webapps/ROOT.war && echo deployed"""
