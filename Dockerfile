FROM tomcat:10.1.41-jdk21

# Xóa ứng dụng mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Thay đổi port Tomcat
RUN sed -i 's/port="8080"/port="8081"/' /usr/local/tomcat/conf/server.xml

# Cấu hình JVM với database connection và JMX monitoring đơn giản
ENV CATALINA_OPTS="-Ddb.host=host.docker.internal \
    -Xms512m -Xmx1024m \
    -Djava.awt.headless=true \
    -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.port=9999 \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Dcom.sun.management.jmxremote.ssl=false"

# Copy WAR file
COPY dist/VinfastSystem.war /usr/local/tomcat/webapps/ROOT.war

# Tạo script startup với thông tin đã cập nhật
RUN echo '#!/bin/bash' > /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "🚀 Starting VinfastSystem Application with JMX Monitoring"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "🔗 Database Host: host.docker.internal"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "🎯 JMX Remote: localhost:9999 (for JConsole/VisualVM)"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "📱 Application: http://localhost:8081"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "💡 Connect JConsole to: service:jmx:rmi:///jndi/rmi://localhost:9999/jmxrmi"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'catalina.sh run' >> /usr/local/tomcat/bin/startup-custom.sh && \
    chmod +x /usr/local/tomcat/bin/startup-custom.sh

# Expose ports 
EXPOSE 8081 9999

# Health check (giữ nguyên)
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8081/ || exit 1

# Start application
CMD ["/usr/local/tomcat/bin/startup-custom.sh"]