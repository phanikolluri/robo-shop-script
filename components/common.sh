CHECK_ROOT() {
 USER_ID=$(id -u)
 if [ $USER_ID -ne 0 ]; then
     echo -e "\e[31m You can run this script as root user or sudo with script\e[0m"
     exit 1
 fi
}

