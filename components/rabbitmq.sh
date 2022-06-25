source components/common.sh

CHECK_ROOT

if [ -z "$RABBITMQ_USER_PASSWORD" ]; then
  echo "Env variable RABBITMQ_USER_PASSWORD needed"
  exit 1
fi

PRINT "setup yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
CHECK_STAT $?

PRINT "Install Erlang & Rabbitmq"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm  rabbitmq-server -y &>>${LOG}
CHECK_STAT $?

PRINT "Start Rabbitmq service"
systemctl enable rabbitmq-server &>>${LOG} && systemctl start rabbitmq-server &>>${LOG}
CHECK_STAT $?

PRINT "Create RABBITMQ user"
rabbitmqctl add_user roboshop roboshop123 &>>${LOG}
CHECK_STAT $?

PRINT "RABBITMQ user Tags and Permissions"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
CHECK_STAT $?






