#!/bin/bash
set -eux

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y nginx
  sudo systemctl enable nginx
  sudo systemctl start nginx
  echo "<h1>Hello Bikram!</h1>" | sudo tee /var/www/html/index.html
elif command -v yum >/dev/null 2>&1; then
  sudo yum update -y
  if grep -qi 'Amazon Linux release 2023' /etc/os-release 2>/dev/null; then
    sudo dnf install -y nginx
  else
    sudo amazon-linux-extras enable nginx1 || true
    sudo yum install -y nginx
  fi
  sudo systemctl enable nginx
  sudo systemctl start nginx
  echo "<h1>Hello Bikram!</h1>" | sudo tee /usr/share/nginx/html/index.html
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf update -y
  sudo dnf install -y nginx
  sudo systemctl enable nginx
  sudo systemctl start nginx
  echo "<h1>Hello Bikram!</h1>" | sudo tee /usr/share/nginx/html/index.html
else
  echo "Unsupported OS for nginx installation" >&2
  exit 1
fi