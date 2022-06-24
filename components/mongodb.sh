source components/common.sh

CHECK_ROOT

PRINT "Configure yum repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG}
CHECK_STAT $?

PRINT "Install mongodb"
yum install -y mongodb-org &>>${LOG}
CHECK_STAT $?

PRINT "Configure mongodb service"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
CHECK_STAT $?

PRINT "Start mongodb"
systemctl enable mongod &>>${LOG} && systemctl restart mongod &>>${LOG}
CHECK_STAT $?

PRINT "Download schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>${LOG}
CHECK_STAT $?

PRINT "load schema"
cd /tmp && unzip -o mongodb.zip &>>${LOG} && cd mongodb-main && mongo < catalogue.js &>>${LOG} && mongo < users.js &>>${LOG}
CHECK_STAT $?




