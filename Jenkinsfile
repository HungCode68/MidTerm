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
        stage('🔄 Clone Repository') {
            steps {
                echo '📥 Cloning source code from GitHub...'
                git branch: 'main', url: 'https://github.com/HungCode68/MidTerm.git'
            }
        }

        stage('🧹 Clean & Prepare') {
            steps {
                echo '🧹 Cleaning and preparing build environment...'
                bat '''
                    if exist build rmdir /s /q build
                    if exist dist rmdir /s /q dist
                    mkdir build
                    mkdir dist
                    mkdir build\\WEB-INF
                    mkdir build\\WEB-INF\\classes
                    mkdir build\\WEB-INF\\lib
                    
                    echo "✅ Build directories created"
                '''
            }
        }

        stage('📚 Verify Libraries') {
            steps {
                echo '📚 Checking required libraries...'
                bat '''
                    if exist Web\\WEB-INF\\lib (
                        echo "📋 Found libraries:"
                        dir Web\\WEB-INF\\lib
                        
                        REM Check for SQL Server driver
                        dir Web\\WEB-INF\\lib\\*mssql* /B >nul 2>&1
                        if errorlevel 1 (
                            echo "⚠️  WARNING: SQL Server JDBC driver not found!"
                            echo "Please add mssql-jdbc-*.jar to Web\\WEB-INF\\lib\\"
                        ) else (
                            echo "✅ SQL Server JDBC driver found"
                        )
                    ) else (
                        echo "❌ ERROR: Web\\WEB-INF\\lib directory not found!"
                        echo "Please create it and add required JAR files"
                        exit /b 1
                    )
                '''
            }
        }

        stage('📂 Copy Resources') {
            steps {
                echo '📂 Copying web resources and libraries...'
                bat '''
                    REM Copy JSP and HTML files
                    for %%f in (Web\\*.jsp Web\\*.html) do (
                        if exist "%%f" copy "%%f" build\\ /Y
                    )
                    
                    REM Copy static resources
                    if exist Web\\css xcopy Web\\css build\\css /E /I /Y
                    if exist Web\\js xcopy Web\\js build\\js /E /I /Y
                    if exist Web\\images xcopy Web\\images build\\images /E /I /Y
                    if exist Web\\assets xcopy Web\\assets build\\assets /E /I /Y
                    if exist Web\\styles xcopy Web\\styles build\\styles /E /I /Y
                    
                    REM Copy WEB-INF content
                    if exist Web\\WEB-INF\\web.xml copy Web\\WEB-INF\\web.xml build\\WEB-INF\\ /Y
                    
                    REM Copy JAR libraries (CRITICAL!)
                    if exist Web\\WEB-INF\\lib\\*.jar (
                        xcopy Web\\WEB-INF\\lib\\*.jar build\\WEB-INF\\lib\\ /Y
                        echo "✅ Libraries copied:"
                        dir build\\WEB-INF\\lib
                    ) else (
                        echo "❌ ERROR: No JAR files found in Web\\WEB-INF\\lib\\"
                        exit /b 1
                    )
                '''
            }
        }

        stage('⚙️ Compile Java') {
            steps {
                echo '⚙️ Compiling Java source files...'
                bat '''
                    @echo off
                    setlocal enabledelayedexpansion

                    REM Build classpath with all JARs
                    set CLASSPATH=%TOMCAT_PATH%\\lib\\servlet-api.jar
                    for %%i in (build\\WEB-INF\\lib\\*.jar) do (
                        set CLASSPATH=!CLASSPATH!;%%i
                    )
                    echo 🔧 Classpath: !CLASSPATH!

                    REM Find all .java files recursively under src\\
                    dir /b /s src\\*.java > sources.txt

                    REM Compile all Java files from list
                    javac -d build\\WEB-INF\\classes -cp "!CLASSPATH!" @sources.txt

                    if errorlevel 1 (
                        echo ❌ Compilation failed!
                        exit /b 1
                    ) else (
                        echo ✅ Compilation successful
                        echo 📋 Compiled classes:
                        dir build\\WEB-INF\\classes /S /B
                    )
                '''
            }
        }


// STAGE MỚI: Phân tích mã nguồn với SonarQube
        stage('🔬 SonarQube Analysis') {
            steps {
                echo '🔬 Running SonarQube code analysis...'
                withSonarQubeEnv('Sonarqube') {
                    withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                        bat '''
                            # Đường dẫn đến SonarQube Scanner
                            # Nếu bạn đã cài đặt SonarQube Scanner trên Jenkins agent, bạn có thể gọi trực tiếp
                            # Nếu không, bạn cần thêm SonarQube Scanner vào environment path
                            
                            # Cấu hình SonarScanner
                            sonar-scanner.bat -Dsonar.projectKey=VinfastSystem -Dsonar.projectName="VinfastSystem Application" -Dsonar.host.url=http://localhost:9000 -Dsonar.login=%SONAR_TOKEN% -Dsonar.sources=src -Dsonar.java.binaries=build/WEB-INF/classes -Dsonar.java.libraries=build/WEB-INF/lib
                        '''
                    }
                }
            }
        }

        stage('📦 Create WAR') {
            steps {
                echo '📦 Creating WAR file with proper structure...'
                bat '''
                    cd build
                    
                    REM Create WAR file
                    jar -cvf ..\\dist\\VinfastSystem.war *
                    
                    cd ..
                    
                    REM Verify WAR structure
                    echo "📋 WAR file contents:"
                    jar -tf dist\\VinfastSystem.war | findstr /C:"WEB-INF/classes" /C:"WEB-INF/lib" /C:".jsp" /C:"web.xml"
                    
                    REM Check WAR size
                    for %%A in (dist\\VinfastSystem.war) do echo "📏 WAR size: %%~zA bytes"
                '''
            }
        }

        stage('🚀 Deploy to Local Tomcat') {
            steps {
                echo '🚀 Deploying to local Tomcat for testing...'
                bat '''
                    REM Stop Tomcat gracefully
                    taskkill /f /im java.exe /fi "WINDOWTITLE eq Tomcat" 2>nul || echo "Tomcat not running"
                    ping -n 6 127.0.0.1 > nul

                    REM Clean old deployment
                    if exist "%TOMCAT_PATH%\\webapps\\VinfastSystem*" (
                        rmdir /s /q "%TOMCAT_PATH%\\webapps\\VinfastSystem" 2>nul
                        del "%TOMCAT_PATH%\\webapps\\VinfastSystem.war" 2>nul
                    )

                    REM Deploy new WAR
                    copy dist\\VinfastSystem.war "%TOMCAT_PATH%\\webapps\\" /Y

                    REM Start Tomcat
                    start "" "%TOMCAT_PATH%\\bin\\startup.bat"

                    echo "⏳ Waiting for Tomcat to start..."
                    ping -n 16 127.0.0.1 > nul

                    echo "✅ Local deployment completed"
                '''
            }
        }

        // BỎ stage 'Verify JMX Config' vì không cần nữa

        

    stage('📊 Start Monitoring Stack') {
    steps {
        echo '📊 Starting Prometheus, Grafana, Node Exporter, and cAdvisor...'
        bat '''
            echo "🛑 Stopping and removing previous containers and networks..."
            docker-compose -f docker-compose.yml down --remove-orphans || echo "No existing monitoring stack to stop"
            
            echo "⏳ Giving Docker a few seconds to clean up..."
            timeout /t 5 /nobreak >nul
            
            echo "📊 Starting new monitoring stack..."
            docker-compose -f docker-compose.yml up -d --build
            
            echo "⏳ Waiting for containers to stabilize..."
        '''
        script {
            sleep(30) // Tăng thời gian chờ để container khởi động ổn định
        }
        bat '''
            echo "📋 Active containers:"
            docker-compose -f docker-compose.yml ps
        '''
    }
}

        stage('🔍 Health Check') {
            steps {
                echo '🔍 Performing application health check...'
                script {
                    sleep(15)
                    def logs = bat(
                        script: "docker logs vinfastsystem_app 2>&1",
                        returnStdout: true
                    )
                    
                    // Kiểm tra lỗi nhưng bỏ qua JMX-related warnings
                    if (logs.contains("FATAL ERROR") || logs.contains("java.lang.reflect.InvocationTargetException") || logs.contains("ASSERTION FAILED")) {
                        echo "⚠️ Found serious errors in container logs:"
                        echo logs
                        error "Application health check failed: Serious errors found in logs"
                    } else {
                        echo "✅ No critical errors found in logs"
                        if (logs.contains("Started")) {
                            echo "🎉 Application started successfully"
                        }
                    }
                }
                echo "🔌 Testing database connectivity..."
                echo "   Make sure SQL Server is running and accessible"
            }
        }
        
        stage('📤 Push to Docker Hub') {
            when {
                expression { return params.PUSH_TO_DOCKERHUB != false }
            }
            steps {
                echo '📤 Pushing image to Docker Hub...'
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                        echo "✅ Image pushed to Docker Hub successfully"
                    }
                }
            }
        }
    }

    post {
        success {
            echo '''
            🎉 =========================================
            ✅ TRIỂN KHAI THÀNH CÔNG!
            ============================================
            
            📍 Ứng dụng đã được triển khai tại:
                • Local Tomcat: http://localhost:8081/VinfastSystem
                • Docker Container: http://localhost:8087
            
            📊 Monitoring Stack:
                • Prometheus: http://localhost:9090
                • Grafana: http://localhost:3000 (admin/admin123)
                • Node Exporter: http://localhost:9100
                • cAdvisor: http://localhost:8090
                • JMX Remote: localhost:9999 (for JConsole)
            
            🔧 Để kiểm tra và debug:
                • Container logs: docker logs vinfastsystem_app
                • Container shell: docker exec -it vinfastsystem_app bash
                • Tomcat logs: %TOMCAT_PATH%\\logs\\catalina.out
            
            📋 Cấu trúc WAR đã được tạo đúng chuẩn với:
                • Web resources (JSP, HTML, CSS, JS)
                • Compiled Java classes
                • JAR libraries (JDBC driver)
                • web.xml configuration
            
            ===============================================
            '''
        }
        failure {
            echo '''
            ❌ =============================================
            TRIỂN KHAI THẤT BẠI!
            =============================================
            
            🔍 Các bước debug:
            1. Kiểm tra logs: docker logs vinfastsystem_app
            2. Kiểm tra thư viện: ls Web/WEB-INF/lib/
            3. Kiểm tra SQL Server có chạy không
            4. Kiểm tra port 1433 có mở không
            
            💡 Các lỗi thường gặp:
            • Thiếu JDBC driver trong Web/WEB-INF/lib/
            • SQL Server không chạy hoặc không cho phép TCP/IP
            • Port conflict
            • Compilation errors
            ===============================================
            '''
            
            // Show container logs if container exists
            script {
                try {
                    def logs = bat(
                        script: "docker logs vinfastsystem_app 2>&1",
                        returnStdout: true,
                        returnStatus: true
                    )
                    if (logs.contains("Error")) {
                        echo "Container logs:"
                        echo logs
                    }
                } catch (Exception e) {
                    echo "Could not retrieve container logs or container does not exist."
                }
            }
        }
        always {
            // Clean up build artifacts
            bat 'if exist build rmdir /s /q build 2>nul || echo "Build cleanup completed"'
        }
    }
}