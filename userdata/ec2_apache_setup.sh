#!/bin/bash


yum update -y
yum install -y httpd

systemctl enable httpd
systemctl start httpd

echo "Hello from Standalone EC2" > /var/www/html/index.html
