def SERVICE_NAME="maven-docker-jenkins-demo"
def SERVICE_IMAGE_NAME="maven-docker-jenkins-demo"
def JAVA_OPTIONS="-Xms256m -Xmx512m"

def DOCKER_TAG="latest";

pipeline {
    agent any

    parameters {
        booleanParam(name: 'RELEASE', defaultValue: false , description: 'UAT,PROD勾选')
    }

    stages {
        stage('DEFINE DOCKER TAG NAME') {
            steps {
                script {
                    if (params.RELEASE) {
                        def now = new Date()
                        DOCKER_TAG = now.format("YYYYMMdd")
                    }
                }
            }
        }

        stage('Build image') {
            steps {
                sh "mvn clean package -U jib:build -Dmaven.test.skip=true -DsendCredentialsOverHttp=true -Ddocker-image.version=${DOCKER_TAG}"
            }
        }

        stage('Deploy To SIT') {
            when {
                expression { return !params.RELEASE }
            }
            steps {
                  sh "docker run -d --name ${SERVICE_NAME} -p 8080:8080 \
                                        -e JAVA_OPTIONS='${JAVA_OPTIONS}' \
                                        -e SERVICE_NAME=${SERVICE_NAME} \
                                        ${SERVICE_IMAGE_NAME}"
            }
        }
    }
}
// add jenkis user to docker group to avoid error:
// Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock...
// sudo usermod -a -G docker jenkins
// sudo service jenkins restart
// push images: sh "mvn clean package -U jib:build -Dmaven.test.skip=true -DsendCredentialsOverHttp=true -Ddocker-image.version=${DOCKER_TAG}"
// local images: sh "mvn clean package -U jib:dockerBuild -Dmaven.test.skip=true -Ddocker-image.version=${DOCKER_TAG}"