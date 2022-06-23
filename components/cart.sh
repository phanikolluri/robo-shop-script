source components/common.sh

CHECK_ROOT

echo "Setting Up NODEJS Yum Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
CHECK_STAT $?

echo "Installing NODEJS"
yum install nodejs -y &>>${LOG}
CHECK_STAT $?

echo "Creating application User"
useradd roboshop &>>${LOG}
CHECK_STAT $?

echo "Downloading CART content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>${LOG}
CHECK_STAT $?

cd /home/roboshop

echo "Remove old content"
rm -rf cart &>>${LOG}
CHECK_STAT $?

echo "Extract CART content"
unzip /tmp/cart.zip &>>${LOG}
CHECK_STAT $?

mv cart-main cart
cd cart

echo "Install NODEJS dependencies for cart component"
npm install &>>${LOG}
CHECK_STAT $?

echo "Update Systemd Configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/cart/systemd.service &>>${LOG}
CHECK_STAT $?

echo "Setup Systemd configuration"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>${LOG}
CHECK_STAT $?

systemctl daemon-reload
systemctl restart cart

echo "start CART service"
systemctl enable cart &>>${LOG}
CHECK_STAT $?














