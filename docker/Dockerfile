# mvn clean package

FROM java:8

# JAR_PATH="./target/${SERVICE_NAME}.jar"
ARG JAR_PATH

ADD ${JAR_PATH} /app/app.jar

ADD ./docker/run.sh run.sh
RUN chmod +x run.sh

CMD ["sh", "run.sh"]