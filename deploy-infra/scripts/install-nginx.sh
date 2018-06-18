#!/bin/bash
sudo apt-get update && sudo apt-get install nginx -y

sudo ufw allow 'Nginx HTTP'

sudo systemctl enable nginx
sudo systemctl stop nginx
sudo rm -f /var/www/html/*.html
sudo -s
echo 'Automation for the People' > /var/www/html/index.html
exit
sudo systemctl start nginx
