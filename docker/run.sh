#!/bin/sh

echo ${SERVICE_NAME}

mkdir -p /home/service/${SERVICE_NAME}

mv /app/app.jar /home/service/${SERVICE_NAME}/${SERVICE_NAME}.jar

cd /home/service/${SERVICE_NAME}

java ${JAVA_OPTIONS} -Dapp.name=${SERVICE_NAME} \
    -Djava.security.egd=file:/dev/./urandom -Duser.timezone=Asia/Shanghai \
    -jar ${SERVICE_NAME}.jar