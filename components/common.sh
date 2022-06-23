CHECK_ROOT() {
 USER_ID=$(id -u)
 if [ $USER_ID -ne 0 ]; then
     echo -e "\e[31m You can run this script as root user or sudo with script\e[0m"
     exit 1
 fi
}

CHECK_STAT() {
echo "-----------------------" >>${LOG}
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
  echo "---------- $1 ----------" >>${LOG}
  echo "$1"
}