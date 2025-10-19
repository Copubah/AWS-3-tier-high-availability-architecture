#!/bin/bash
yum update -y
yum install -y httpd php php-mysql

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create a simple PHP info page
cat > /var/www/html/index.php << 'EOF'
<?php
echo "<h1>Web Server - Three Tier Architecture</h1>";
echo "<p>Server IP: " . $_SERVER['SERVER_ADDR'] . "</p>";
echo "<p>Client IP: " . $_SERVER['REMOTE_ADDR'] . "</p>";
echo "<p>Timestamp: " . date('Y-m-d H:i:s') . "</p>";
phpinfo();
?>
EOF

# Set proper permissions
chown apache:apache /var/www/html/index.php
chmod 644 /var/www/html/index.php

# Configure firewall
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload