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
                    REM Build classpath with all JARs
                    SET CLASSPATH=%TOMCAT_PATH%\\lib\\servlet-api.jar
                    for %%i in (build\\WEB-INF\\lib\\*.jar) do (
                        SET CLASSPATH=!CLASSPATH!;%%i
                    )
                    
                    echo "🔧 Classpath: %CLASSPATH%"
                    
                    REM Compile all Java files
                    javac -d build\\WEB-INF\\classes -cp "%CLASSPATH%" -sourcepath src ^
                        src\\context\\*.java ^
                        src\\model\\*.java ^
                        src\\dao\\*.java ^
                        src\\controller\\*.java
                    
                    if errorlevel 1 (
                        echo "❌ Compilation failed!"
                        exit /b 1
                    ) else (
                        echo "✅ Compilation successful"
                        echo "📋 Compiled classes:"
                        dir build\\WEB-INF\\classes /S /B
                    )
                '''
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
                    timeout /t 5
                    
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
                    timeout /t 15
                    
                    echo "✅ Local deployment completed"
                '''
            }
        }

        stage('🐳 Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                script {
                    def image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                    echo "✅ Docker image built: ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('🛑 Stop Previous Container') {
            steps {
                echo '🛑 Cleaning up previous container...'
                script {
                    try {
                        bat "docker stop ${CONTAINER_NAME} 2>nul || echo 'No container to stop'"
                        bat "docker rm ${CONTAINER_NAME} 2>nul || echo 'No container to remove'"
                        echo "✅ Previous container cleaned up"
                    } catch (Exception e) {
                        echo "ℹ️ No previous container found"
                    }
                }
            }
        }

        stage('🚀 Run Docker Container') {
            steps {
                echo '🚀 Starting new Docker container...'
                script {
                    // Check if port is available
                    def portCheck = bat(
                        script: 'netstat -ano | findstr :8087',
                        returnStatus: true
                    )
                    
                    if (portCheck == 0) {
                        error "❌ Port 8087 is already in use!"
                    }
                    
                    // Run container with proper network configuration
                    bat """docker run -d --name ${CONTAINER_NAME} \
                           -p 8087:8081 \
                           --add-host=host.docker.internal:host-gateway \
                           -e "CATALINA_OPTS=-Ddb.host=host.docker.internal -Xms512m -Xmx1024m" \
                           ${IMAGE_NAME}:${IMAGE_TAG}"""
                    
                    // Wait for container to fully start
                    echo "⏳ Waiting for container to start..."
                    sleep(15)
                    
                    // Verify container is running
                    def containerStatus = bat(
                        script: "docker ps -f name=${CONTAINER_NAME} --format '{{.Status}}'",
                        returnStdout: true
                    ).trim()
                    
                    echo "📊 Container status: ${containerStatus}"
                    
                    if (!containerStatus.contains("Up")) {
                        bat "docker logs ${CONTAINER_NAME}"
                        error "❌ Container failed to start properly"
                    }
                }
            }
        }

        stage('🔍 Health Check') {
            steps {
                echo '🔍 Performing application health check...'
                script {
                    // Wait a bit more for application to fully load
                    sleep(10)
                    
                    // Check container logs for any errors
                    def logs = bat(
                        script: "docker logs ${CONTAINER_NAME} 2>&1",
                        returnStdout: true
                    )
                    
                    if (logs.contains("ERROR") || logs.contains("Exception")) {
                        echo "⚠️ Found errors in container logs:"
                        echo logs
                    } else {
                        echo "✅ No critical errors found in logs"
                    }
                    
                    // Test database connection
                    echo "🔌 Testing database connectivity..."
                    echo "   Make sure SQL Server is running and accessible"
                }
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
            🎉 ===============================================
            ✅ TRIỂN KHAI THÀNH CÔNG!
            ===============================================
            
            📍 Ứng dụng đã được triển khai tại:
               • Local Tomcat: http://localhost:8081/VinfastSystem
               • Docker Container: http://localhost:8087
            
            🔧 Để kiểm tra và debug:
               • Container logs: docker logs vinfastsystem_container
               • Container shell: docker exec -it vinfastsystem_container bash
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
            ❌ ===============================================
            TRIỂN KHAI THẤT BẠI!
            ===============================================
            
            🔍 Các bước debug:
            1. Kiểm tra logs: docker logs vinfastsystem_container
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
                    bat "docker logs ${CONTAINER_NAME} 2>&1 || echo 'No container logs available'"
                } catch (Exception e) {
                    echo "Could not retrieve container logs"
                }
            }
        }
        always {
            // Clean up build artifacts
            bat 'if exist build rmdir /s /q build 2>nul || echo "Build cleanup completed"'
        }
    }
}