pipeline {
    agent any

    environment {
        TOMCAT_PATH = 'C:\\apache-tomcat-10.1.41'
        TOMCAT_PORT = '9090' // Bạn có thể thay đổi port tại đây
    }

    stages {
        stage('Clone') {
            steps {
                echo 'Cloning source code from GitHub'
                git branch: 'main', url: 'https://github.com/HungCode68/MidTerm.git'
            }
        }

        stage('Build WAR') {
            steps {
                echo 'Compiling and packaging WAR file'
                bat '''
                    mkdir build 2>nul
                    javac -d build -cp "%TOMCAT_PATH%\\lib\\servlet-api.jar" -sourcepath src ^
                        src\\dao\\*.java ^
                        src\\model\\*.java ^
                        src\\controller\\*.java ^
                        src\\context\\*.java

                    xcopy Web\\* build /E /I /Y
                    cd build
                    jar -cvf VinfastSystem.war *
                '''
            }
        }

      stage('Configure Port') {
    steps {
        echo "Changing Tomcat HTTP port to ${env.TOMCAT_PORT}"
        bat """
            powershell -Command ^
            "\$config = Get-Content -Raw '${env.TOMCAT_PATH}\\conf\\server.xml'; ^
             \$config = \$config -replace 'port=\\"[0-9]+\\" protocol=\\"HTTP/1.1\\"', 'port=\\"${env.TOMCAT_PORT}\\" protocol=\\"HTTP/1.1\\"'; ^
             Set-Content -Path '${env.TOMCAT_PATH}\\conf\\server.xml' -Value \$config"
        """
    }
}


        stage('Deploy to Tomcat') {
            steps {
                echo 'Deploying WAR file to Tomcat'
                bat '''
                    if not exist "%TOMCAT_PATH%\\webapps" (
                        echo "Tomcat webapps folder not found!"
                        exit /b 1
                    )
                    copy build\\VinfastSystem.war "%TOMCAT_PATH%\\webapps\\" /Y
                '''
            }
        }

        stage('Restart Tomcat') {
            steps {
                echo 'Restarting Tomcat server'
                bat '''
                    call "%TOMCAT_PATH%\\bin\\shutdown.bat"
                    timeout /t 5 >nul
                    call "%TOMCAT_PATH%\\bin\\startup.bat"
                '''
            }
        }
    }
}
