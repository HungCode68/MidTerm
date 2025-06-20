pipeline {
    agent any

    environment {
        CATALINA_HOME = "C:\\apache-tomcat-10.1.41"
        WAR_NAME = "VinfastSystem.war"
    }

    stages {
        stage('Clone') {
            steps {
                echo 'Cloning source code from GitHub'
                git url: 'https://github.com/HungCode68/MidTerm.git', branch: 'main'
            }
        }

        stage('Build WAR') {
            steps {
                echo 'Compiling and packaging WAR file'
                bat '''
                if not exist build mkdir build

                :: Dùng PowerShell để lấy danh sách tất cả file .java
                powershell -Command "Get-ChildItem -Recurse -Filter *.java -Path src | ForEach-Object { $_.FullName } | Set-Content java-files.txt"

                :: Biên dịch tất cả file java
                javac -d build -cp "%CATALINA_HOME%\\lib\\servlet-api.jar" @java-files.txt

                :: Copy file JSP và HTML vào thư mục build
                xcopy Web\\* build /E /I /Y

                :: Tạo file WAR
                cd build
                jar -cvf %WAR_NAME% *
                '''
            }
        }

        stage('Configure Port') {
            steps {
                echo 'Changing Tomcat HTTP port to 9090'
                bat '''
                powershell -Command "$config = Get-Content -Raw '%CATALINA_HOME%\\conf\\server.xml'; `
                $config = $config -replace 'port=\\"[0-9]+\\" protocol=\\"HTTP/1.1\\"', 'port=\\"9090\\" protocol=\\"HTTP/1.1\\"'; `
                Set-Content -Path '%CATALINA_HOME%\\conf\\server.xml' -Value $config"
                '''
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo 'Deploying WAR to Tomcat'
                bat '''
                copy build\\%WAR_NAME% %CATALINA_HOME%\\webapps /Y
                '''
            }
        }

        stage('Restart Tomcat') {
            steps {
                echo 'Restarting Tomcat server'
                bat '''
                call %CATALINA_HOME%\\bin\\shutdown.bat
                timeout /t 5
                call %CATALINA_HOME%\\bin\\startup.bat
                '''
            }
        }
    }
}
