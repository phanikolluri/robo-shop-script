CHECK_ROOT() {
 USER_ID=$(id -u)
 if [ $USER_ID -ne 0 ]; then
     echo -e "\e[31m You can run this script as root user or sudo with script\e[0m"
     exit 1
 fi
}

CHECK_STAT() {
echo "-------------------------" >>${LOG}
if [ $1 -ne 0 ]; then
  echo -e "\e[31mFAILED\e[0m"
  echo -e "\n Check log file - ${LOG} for errors\n"
  exit 2
else
  echo -e "\e[32mSUCCESS\e[0m"
fi
}

LOG=/tmp/roboshop.log
rm -f $LOG

PRINT() {
  echo "------------- $1 -------------" >>${LOG}
  echo "$1"
}


APP_COMMON_SETUP() {
  PRINT "Creating application User"
    id roboshop &>>${LOG}
    if [ $? -ne 0 ]; then
      useradd roboshop &>>${LOG}
    fi
    CHECK_STAT $?

    PRINT "Downloading ${COMPONENT} content"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG}
    CHECK_STAT $?

    cd /home/roboshop

    PRINT "Remove old content"
    rm -rf ${COMPONENT} &>>${LOG}
    CHECK_STAT $?

    PRINT "Extract ${COMPONENT} content"
    unzip -o /tmp/${COMPONENT}.zip &>>${LOG}
    CHECK_STAT $?
}

SYSTEMD() {
  PRINT "Update Systemd Configuration"
    sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG}
    CHECK_STAT $?

    PRINT "Setup Systemd configuration"
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG} && systemctl daemon-reload
    CHECK_STAT $?


    PRINT "start ${COMPONENT} service"
    systemctl enable ${COMPONENT} &>>${LOG} && systemctl restart ${COMPONENT}  &>>${LOG}
    CHECK_STAT $?

}

NODEJS() {
  source components/common.sh

  CHECK_ROOT

  PRINT "Setting Up NODEJS Yum Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  CHECK_STAT $?

  PRINT "Installing NODEJS"
  yum install nodejs -y &>>${LOG}
  CHECK_STAT $?

  APP_COMMON_SETUP

  PRINT "Install NODEJS dependencies for ${COMPONENT} component"
  mv ${COMPONENT}-main ${COMPONENT} && cd ${COMPONENT} && npm install &>>${LOG}
  CHECK_STAT $?

  SYSTEMD

}

NGINX() {
  CHECK_ROOT
  PRINT "Installing Nginx"
  yum install nginx -y &>>${LOG}
  CHECK_STAT $?

  PRINT "Download ${COMPONENT} content"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG}
  CHECK_STAT $?

  PRINT "remove old content"
  cd /usr/share/nginx/html
  rm -rf * &>>${LOG}
  CHECK_STAT $?

  PRINT "Extract ${COMPONENT} content"
  unzip /tmp/${COMPONENT}.zip &>>${LOG}
  CHECK_STAT $?

  PRINT "Organise ${COMPONENT} content"
  mv ${COMPONENT}-main/* . && mv static/* . &&  rm -rf ${COMPONENT}-main README.md && mv localhost.conf /etc/nginx/default.d/roboshop.conf
  CHECK_STAT $?


  PRINT "update ${COMPONENT} configuration"
  sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/'  /etc/nginx/default.d/roboshop.conf
  CHECK_STAT $?

  PRINT "start Nginx service"
  systemctl enable nginx &>>${LOG} && systemctl restart nginx &>>${LOG}
  CHECK_STAT $?

}

MAVEN() {

  CHECK_ROOT

  PRINT "Installing maven"
  yum install maven -y &>>${LOG}
  CHECK_STAT $?

  APP_COMMON_SETUP

  PRINT "compile ${COMPONENT} code"
  mv ${COMPONENT}-main ${COMPONENT} && cd ${COMPONENT} && mvn clean package &>>${LOG} && mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar
  CHECK_STAT $?

  SYSTEMD

}

PYTHON() {
  
  CHECK_ROOT

  PRINT "Install python-3"
  yum install python36 gcc python3-devel -y &>>${LOG
  CHECK_STAT $?

  APP_COMMON_SETUP 
                   

  PRINT "Install ${COMPONENT} dependencies"
  mv ${COMPONENT}-main ${COMPONENT} && cd /home/roboshop/${COMPONENT} && pip3 install -r requirements.txt &>>${LOG
  CHECK_STAT $?

  USER_ID=$(id -u roboshop)
  GROUP_ID=$(id -g roboshop)

  PRINT "UPDATE ${COMPONENT} configuration"
  sed -i -e "/^uid/ c uid = ${USER_ID}" -e "/^gid/ c gid = ${GROUP_ID}" /home/roboshop/${COMPONENT}/${COMPONENT}.ini
  CHECK_STAT $?

  oshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
  /systemd.service /etc/systemd/system/${COMPONENT}.service

   SYSTEMD 

}