def SERVICE_NAME="maven-docker-jenkins-demo"
def SERVICE_IMAGE_NAME="maven-docker-jenkins-demo-img"
def JAR_PATH="./target/demo-0.0.1-SNAPSHOT.jar"
def DOCKER_FILE_PATH="./docker/Dockerfile"
def JAVA_OPTIONS="-Xms256m -Xmx512m"

pipeline {
    agent any

    stages {
        stage('Init build parameter') {
            steps {
                echo "[ INFO ] [ Init ] ========== initialize build parameter =========="
                echo "[ INFO ] [ Init ] SERVICE_NAME is ${SERVICE_NAME} "
            }
        }

        stage('Build artifact') {
            steps {
                echo "[ INFO ] [ Build artifact ] ========== Starting build artifact =========="
                sh "mvn clean package -Dproject.version= -Dmaven.test.skip=true -U "
            }
        }

        stage('Build image') {
            agent any
            steps {
                script {
                    echo "[ INFO ] [ Build image ] ========== start build docker image =========="
                    sh "sudo docker build -f ${DOCKER_FILE_PATH} --build-arg JAR_PATH=${JAR_PATH} -t ${SERVICE_IMAGE_NAME} ."
                }
            }
        }

        stage('Deploy') {
            agent any
            steps {
                echo '[ INFO ] [ Deploy ] ========== start deploy =========='
                script{
                    try {
                        sh "sudo docker rmi -f ${SERVICE_IMAGE_NAME}"
                    } catch (err) {
                        echo '[ INFO ] [ Deploy ] ========== container not exist ! =========='
                    }

                    sh "sudo docker run -d --name ${SERVICE_NAME} -p 8080:8080 \
                        -e JAVA_OPTIONS='${JAVA_OPTIONS}' \
                        -e SERVICE_NAME=${SERVICE_NAME} \
                        ${SERVICE_IMAGE_NAME}"

                }
            }
        }
    }
}
