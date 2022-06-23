source components/common.sh

CHECK_ROOT

PRINT "Setting Up NODEJS Yum Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
CHECK_STAT $?

PRINT "Installing NODEJS"
yum install nodejs -y &>>${LOG}
CHECK_STAT $?

PRINT "Creating application User"
id roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG}
fi
CHECK_STAT $?

PRINT "Downloading CART content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>${LOG}
CHECK_STAT $?

cd /home/roboshop

PRINT "Remove old content"
rm -rf cart &>>${LOG}
CHECK_STAT $?

PRINT "Extract CART content"
unzip  /tmp/cart.zip &>>${LOG}
CHECK_STAT $?

PRINT cart-main cart
cd cart

PRINT "Install NODEJS dependencies for cart component"
npm  install &>>${LOG}
CHECK_STAT $?

PRINT "Update Systemd Configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/cart/systemd.service &>>${LOG}
CHECK_STAT $?

PRINT "Setup Systemd configuration"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>${LOG}
CHECK_STAT $?

systemctl daemon-reload
systemctl restart cart

PRINT "start CART service"
systemctl enable cart &>>${LOG}
CHECK_STAT $?














