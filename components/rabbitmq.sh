yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
yum install rabbitmq-server -y
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

REDIS

curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
yum install redis-6.2.7 -y

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf


systemctl enable redis
systemctl restart redis


