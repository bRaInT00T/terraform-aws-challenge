#!/bin/bash


yum update -y
yum install -y httpd mod_ssl
systemctl enable httpd
systemctl start httpd

# Create a self-signed cert
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/pki/tls/private/selfsigned.key \
  -out /etc/pki/tls/certs/selfsigned.crt \
  -subj "/CN=localhost"

# Update Apache SSL config
sed -i 's#^SSLCertificateFile .*#SSLCertificateFile /etc/pki/tls/certs/selfsigned.crt#' /etc/httpd/conf.d/ssl.conf
sed -i 's#^SSLCertificateKeyFile .*#SSLCertificateKeyFile /etc/pki/tls/private/selfsigned.key#' /etc/httpd/conf.d/ssl.conf

systemctl restart httpd

echo "Hello from ASG instance over HTTPS" > /var/www/html/index.html
