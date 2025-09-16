#!/bin/bash


sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Hello from Terraform and Apache on RHEL!</h1>" | sudo tee /var/www/html/index.html
