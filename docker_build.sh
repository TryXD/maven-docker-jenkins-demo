#!/usr/bin/env bash

mvn clean package

SERVICE_NAME="maven-docker-jenkins-demo"
SERVICE_IMAGE_NAME="maven-docker-jenkins-demo-img"
JAR_PATH="./target/demo-0.0.1-SNAPSHOT.jar"
DOCKER_FILE_PATH="./docker/Dockerfile"
JAVA_OPTIONS="-Xms256m -Xmx512m"

docker rmi -f ${SERVICE_IMAGE_NAME}

docker build -f ${DOCKER_FILE_PATH} --build-arg JAR_PATH=${JAR_PATH} -t ${SERVICE_IMAGE_NAME} .

docker run -it --rm --name ${SERVICE_NAME} -p 8080:8080 \
        -e JAVA_OPTIONS="${JAVA_OPTIONS}" \
        -e SERVICE_NAME=${SERVICE_NAME} \
        ${SERVICE_IMAGE_NAME}


