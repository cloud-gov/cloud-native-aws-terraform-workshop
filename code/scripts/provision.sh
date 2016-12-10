#!/usr/bin/env bash

. /etc/environment

# install dependencies
yum update -y
yum install -y httpd24 php56 php56-mysqlnd php56-mbstring
export HOME=/root

# configure apache httpd
rm /etc/httpd/conf.modules.d/00-dav.conf /etc/httpd/conf.modules.d/00-proxy.conf /etc/httpd/conf.modules.d/01-cgi.conf
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php.ini
echo ". /etc/environment" | cat - /etc/init.d/httpd > /tmp/httpd && mv /tmp/httpd /etc/init.d/httpd
chmod +x /etc/init.d/httpd
aws s3 cp s3://18f-terraform-workshop/httpd.conf /etc/httpd/conf/httpd.conf
rm -rf /var/www/html
groupadd www
usermod -a -G www apache
chown -R ec2-user:www /var/www
find /var/www -type d -exec chmod 2750 {} +
find /var/www -type f -exec chmod 0640 {} +

# install cloudwatch
curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
chmod +x ./awslogs-agent-setup.py
./awslogs-agent-setup.py -n -r us-east-1 -c s3://18f-terraform-workshop/cloudwatch.conf

# configure autodeploy
aws s3 cp s3://18f-terraform-workshop/deploy.sh /home/ec2-user/deploy.sh
chown ec2-user /home/ec2-user/deploy.sh
chmod +x /home/ec2-user/deploy.sh
su ec2-user -c "/home/ec2-user/deploy.sh"
echo "* * * * * /home/ec2-user/deploy.sh" | crontab -u ec2-user -

# turn on httpd
service httpd start
chkconfig httpd on