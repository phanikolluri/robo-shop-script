#!/bin/bash/

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
cd /home/roboshop
rm -rf catalogue 
unzip /tmp/catalogue.zip
mv catalogue-main catalogue
cd /home/roboshop/catalogue
npm install

#Update SystemD file with correct IP addresses

#Update `MONGO_DNSNAME` with MongoDB Server IP

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue
