#!/bin/bash
sudo apt-get install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx



wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip
sudo apt install unzip
sudo unzip AmazonCloudWatchAgent.zip
sudo ./install.sh
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c ssm:/cloudwatch-agent/config -s
