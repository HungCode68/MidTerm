pipeline {
    agent any

    environment {
        IMAGE_NAME = 'hungcode68/finalterm'
        IMAGE_TAG = 'latest'
        CONTAINER_NAME = 'vinfastsystem_container'
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
        TOMCAT_PATH = 'C:\\apache-tomcat-10.1.41'
    }

    stages {
        stage('Clone') {
            steps {
                echo '📥 Cloning source code from GitHub'
                git branch: 'main', url: 'https://github.com/HungCode68/MidTerm.git'
            }
        }

        stage('Build WAR') {
            steps {
                echo '📦 Compiling and packaging WAR file...'
                bat '''
                    if exist build rmdir /s /q build
                    mkdir build
                    javac -d build -cp "%TOMCAT_PATH%\\lib\\servlet-api.jar" -sourcepath src ^
                        src\\dao\\*.java ^
                        src\\model\\*.java ^
                        src\\controller\\*.java ^
                        src\\context\\*.java
                    
                    xcopy Web\\* build /E /I /Y
                    cd build
                    jar -cvf VinfastSystem.war *
                    cd ..
                '''
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo '🚀 Deploying WAR file to Tomcat (8081)'
                bat '''
                    if not exist "%TOMCAT_PATH%\\webapps" (
                        echo "Tomcat webapps folder not found!"
                        exit /b 1
                    )
                    copy build\\VinfastSystem.war "%TOMCAT_PATH%\\webapps\\" /Y
                '''
            }
        }

    

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image from WAR...'
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Stop Previous Container') {
            steps {
                echo '🛑 Stopping and removing previous container if exists...'
                script {
                    def containerId = bat(
                        script: "docker ps -aq -f name=${CONTAINER_NAME}",
                        returnStdout: true
                    ).trim()

                    if (containerId) {
                        bat "docker stop ${CONTAINER_NAME} || exit 0"
                        bat "docker rm ${CONTAINER_NAME} || exit 0"
                        echo "✅ Container ${CONTAINER_NAME} stopped and removed."
                    } else {
                        echo "ℹ️ No existing container found. Skipping."
                    }
                }
            }
        }

        stage('Run New Container') {
            steps {
                echo '🚀 Running new container on port 8087 (maps to 8081 in container)...'
                script {
                    def portInUse = bat(
                        script: 'netstat -ano | findstr :8087',
                        returnStatus: true
                    ) == 0

                    if (portInUse) {
                        error "❌ Port 8087 is already in use. Please free the port before retrying."
                    }

                    bat "docker run -d --name ${CONTAINER_NAME} -p 8087:8081 ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo '📦 Pushing image to Docker Hub...'
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Triển khai Java Web App thành công:'
            echo '    - Trên Tomcat local tại http://localhost:8081'
            echo '    - Trên Docker container tại http://localhost:8087'
        }
        failure {
            echo '❌ Có lỗi xảy ra trong quá trình triển khai!'
        }
    }
}
