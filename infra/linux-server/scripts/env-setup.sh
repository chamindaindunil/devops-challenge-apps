#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Installing Node.js and NPM..."
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs

echo "Installing Nginx..."
apt-get install -y nginx

echo "Installing Certbot..."
apt-get install -y certbot python3-certbot-nginx

read -p "Enter the domain for the Web App (e.g., web.example.com): " WEB_DOMAIN
read -p "Enter the domain for the API (e.g., api.example.com): " API_DOMAIN

echo "Creating Nginx configuration for Web App..."
cat <<EOF > /etc/nginx/conf.d/web-app.conf
server {
    listen 80;
    server_name $WEB_DOMAIN;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

echo "Creating Nginx configuration for API..."
cat <<EOF > /etc/nginx/conf.d/api-app.conf
server {
    listen 80;
    server_name $API_DOMAIN;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

echo "Enabling Nginx configuration files..."

echo "Restarting Nginx..."
nginx -t && systemctl restart nginx

echo "Provisioning SSL certificates..."
certbot --nginx -d $WEB_DOMAIN
certbot --nginx -d $API_DOMAIN

echo "Environment setup completed successfully!"
