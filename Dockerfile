FROM tomcat:10.1.41-jdk21

# Xóa ứng dụng mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Thay đổi port Tomcat
RUN sed -i 's/port="8080"/port="8081"/' /usr/local/tomcat/conf/server.xml

# Tải JMX Exporter
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.18.0/jmx_prometheus_javaagent-0.18.0.jar /usr/local/tomcat/lib/

# Copy file cấu hình JMX Exporter
COPY jmx-config.yaml /usr/local/tomcat/lib/

# Cấu hình JVM với database connection và JMX monitoring + Prometheus exporter
ENV CATALINA_OPTS="-Ddb.host=host.docker.internal \
 -Ddb.port=1433 -Ddb.name=VinfastSystem -Ddb.user=sa -Ddb.password=123 \
 -Xms512m -Xmx1024m -Djava.awt.headless=true \
 -Dcom.sun.management.jmxremote \
 -Dcom.sun.management.jmxremote.port=9999 \
 -Dcom.sun.management.jmxremote.authenticate=false \
 -Dcom.sun.management.jmxremote.ssl=false \
 -javaagent:/usr/local/tomcat/lib/jmx_prometheus_javaagent-0.18.0.jar=8082:/usr/local/tomcat/lib/jmx-config.yaml"


# Copy WAR file
COPY dist/VinfastSystem.war /usr/local/tomcat/webapps/ROOT.war

# Tạo script startup với thông tin đã cập nhật
RUN echo '#!/bin/bash' > /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "🚀 Starting VinfastSystem Application with JMX Monitoring + Prometheus Metrics"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "🔗 Database Host: host.docker.internal"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "🎯 JMX Remote: localhost:9999 (for JConsole/VisualVM)"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "📊 Prometheus Metrics: http://localhost:8082/metrics"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "📱 Application: http://localhost:8081"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'echo "💡 Connect JConsole to: service:jmx:rmi:///jndi/rmi://localhost:9999/jmxrmi"' >> /usr/local/tomcat/bin/startup-custom.sh && \
    echo 'catalina.sh run' >> /usr/local/tomcat/bin/startup-custom.sh && \
    chmod +x /usr/local/tomcat/bin/startup-custom.sh

# Expose ports: 8081 (app), 9999 (JMX), 8082 (Prometheus metrics)
EXPOSE 8081 9999 8082

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8081/ || exit 1

# Start application
CMD ["/usr/local/tomcat/bin/startup-custom.sh"]
