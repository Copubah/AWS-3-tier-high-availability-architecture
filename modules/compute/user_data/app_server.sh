#!/bin/bash
yum update -y
yum install -y java-11-openjdk mysql

# Install application dependencies
yum groupinstall -y "Development Tools"

# Create application directory
mkdir -p /opt/app
chown ec2-user:ec2-user /opt/app

# Create a simple application service
cat > /etc/systemd/system/app.service << 'EOF'
[Unit]
Description=Three Tier Application
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/app
ExecStart=/usr/bin/java -jar /opt/app/app.jar
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable app