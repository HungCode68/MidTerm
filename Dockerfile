FROM tomcat:10.1.41-jdk21

# Xóa ứng dụng mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Cấu hình JVM và database connection
ENV CATALINA_OPTS="-Ddb.host=host.docker.internal -Xms512m -Xmx1024m -Djava.awt.headless=true"

# Copy WAR file
COPY dist/VinfastSystem.war /usr/local/tomcat/webapps/ROOT.war

# Tạo script startup để log thông tin
RUN echo '#!/bin/bash' > /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "🚀 Starting VinfastSystem Application"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "🔗 Database Host: $${CATALINA_OPTS}"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "📱 Application will be available at: http://localhost:8081"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'catalina.sh run' >> /usr/local/tomcat/bin/startup-custom.sh && \
    chmod +x /usr/local/tomcat/bin/startup-custom.sh

# Expose port
EXPOSE 8081

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8081/ || exit 1

# Start application
CMD ["/usr/local/tomcat/bin/startup-custom.sh"]