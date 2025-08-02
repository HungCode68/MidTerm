FROM tomcat:10.1.41-jdk21

# Xóa ứng dụng mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Thay đổi port Tomcat
RUN sed -i 's/port="8080"/port="8081"/' /usr/local/tomcat/conf/server.xml

# Download JMX Prometheus Java Agent
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.19.0/jmx_prometheus_javaagent-0.19.0.jar /opt/jmx_prometheus_javaagent.jar

# Copy JMX config
COPY monitoring/jmx/jmx_config.yml /opt/jmx_config.yml

# Cấu hình JVM với database connection VÀ JMX monitoring
ENV CATALINA_OPTS="-Ddb.host=host.docker.internal \
    -Xms512m -Xmx1024m \
    -Djava.awt.headless=true \
    -javaagent:/opt/jmx_prometheus_javaagent.jar=8082:/opt/jmx_config.yml \
    -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.port=9999 \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Dcom.sun.management.jmxremote.ssl=false"

# Copy WAR file
COPY dist/VinfastSystem.war /usr/local/tomcat/webapps/ROOT.war

# Tạo script startup để log thông tin (cập nhật với JMX info)
RUN echo '#!/bin/bash' > /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "🚀 Starting VinfastSystem Application with Monitoring"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "🔗 Database Host: host.docker.internal"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "📊 JMX Metrics: http://localhost:8082/metrics"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "🎯 JMX Remote: localhost:9999"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "📱 Application: http://localhost:8081"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'catalina.sh run' >> /usr/local/tomcat/bin/startup-custom.sh && \
    chmod +x /usr/local/tomcat/bin/startup-custom.sh

# Expose ports (thêm JMX ports)
EXPOSE 8081 8082 9999

# Health check (giữ nguyên)
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8081/ || exit 1

# Start application
CMD ["/usr/local/tomcat/bin/startup-custom.sh"]