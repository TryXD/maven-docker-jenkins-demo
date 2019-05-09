def SERVICE_NAME="maven-docker-jenkins-demo"
def SERVICE_IMAGE_NAME="maven-docker-jenkins-demo-img"
def JAR_PATH="./target/demo-0.0.1-SNAPSHOT.jar"
def DOCKER_FILE_PATH="./docker/Dockerfile"
def JAVA_OPTIONS="-Xms256m -Xmx512m"

def BRANCH=""

pipeline {
    agent any

    stages {
        stage('Init build parameter') {
            steps {
                echo "[ INFO ] [ Init ] ========== initialize build parameter =========="
                echo "[ INFO ] [ Init ] SERVICE_NAME is ${SERVICE_NAME} "
                sh "env"
                // test run sh file
                sh "chmod 777 ./test.sh"
                sh "chmod 777 ./issue.sh"
                script {
                    if ( env.BRANCH_NAME == 'master' ){
                         sh "./test.sh"
                    }else{
                        BRANCH = "${env.BRANCH_NAME}".split('#')
                        echo "${BRANCH}"
                        sh "./issue.sh ${BRANCH}"
                    }
                }
            }
        }

        // 使用本机maven build
        // stage('Build artifact') {
        //     steps {
        //         echo "[ INFO ] [ Build artifact ] ========== Starting build artifact =========="
        //         sh "mvn clean package -Dproject.version= -Dmaven.test.skip=true -U "
        //     }
        // }
        // or 使用docker maven容器build
        stage('Build artifact') {
            agent {
                docker {
                    image 'maven:3-jdk-8'
                    args  '-v /root/dev/maven-repos:/root/.m2'
                }
            }
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
                    try {
                        sh "docker stop ${SERVICE_NAME}"
                    } catch (err) {
                        echo '[ INFO ] [ Deploy ] ========== containner stopped or not exist ! =========='
                    }
                    try {
                        sh "docker rm ${SERVICE_NAME}"
                    } catch (err) {
                        echo '[ INFO ] [ Deploy ] ========== containner not exist ! =========='
                    }
                    try {
                        sh "docker rmi -f ${SERVICE_IMAGE_NAME}"
                    } catch (err) {
                        echo '[ INFO ] [ Deploy ] ========== image not exist ! =========='
                    }
                    sh "docker build -f ${DOCKER_FILE_PATH} --build-arg JAR_PATH=${JAR_PATH} -t ${SERVICE_IMAGE_NAME} ."
                }
            }
        }

        stage('Deploy') {
            steps {
                echo '[ INFO ] [ Deploy ] ========== start deploy =========='
                script{

                    sh "docker run -d --name ${SERVICE_NAME} -p 8080:8080 \
                        -e JAVA_OPTIONS='${JAVA_OPTIONS}' \
                        -e SERVICE_NAME=${SERVICE_NAME} \
                        ${SERVICE_IMAGE_NAME}"

                }
            }
        }
    }
}
// add jenkis user to docker group to avoid error:
// Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock...
// sudo usermod -a -G docker jenkins
// sudo service jenkins restart