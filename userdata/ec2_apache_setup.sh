#!/bin/bash


exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "===== Starting Apache setup at $(date) ====="

yum update -y

# Install Apache
if yum install -y httpd; then
  echo "Apache installed successfully"
else
  echo "Apache install failed" >&2
fi

systemctl enable httpd
systemctl start httpd

# Create test page
echo "<html><h1>Apache is running on $(hostname -f)</h1></html>" > /var/www/html/index.html

echo "===== Finished Apache setup at $(date) ====="