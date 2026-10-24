"#!/usr/bin/env bash
set -euo pipefail

# 1) 1 GB swap because t3.micro has only 1 GB RAM
if ! swapon --show | grep -q /swapfile; then
  sudo fallocate -l 1G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi"
"# 2) Docker Engine from Docker's official apt repository
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo ""deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable"" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker ubuntu"
"# 3) Tomcat 9 in a container; webapps and logs live on the host
sudo mkdir -p /opt/tomcat/webapps /opt/tomcat/logs
sudo chown -R ubuntu:ubuntu /opt/tomcat
sudo docker run -d --name tomcat --restart unless-stopped \
  -p 8080:8080 \
  -v /opt/tomcat/webapps:/usr/local/tomcat/webapps \
  -v /opt/tomcat/logs:/usr/local/tomcat/logs \
  -e JAVA_OPTS=""-Xms128m -Xmx256m"" \
  tomcat:9.0-jdk17"
