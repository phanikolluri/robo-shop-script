source components/common.sh

CHECK_ROOT



#PRINT "Download schema"
#curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>${LOG}
#CHECK_STAT $?

#PRINT "Load schema"
#cd /tmp && unzip -o mysql.zip &>>${LOG} && cd mysql-main && mysql -u root -p"${MYSQL_PASSWORD}" <shipping.sql &>>${LOG}
#CHECK_STAT $?


