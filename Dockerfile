FROM tomcat:10.1.41-jdk21

# Xoá ứng dụng mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# ❌ KHÔNG CẦN đổi cổng nữa vì bạn đã chỉnh thành 8081 từ trước
# RUN sed -i 's/port="8080"/port="8081"/' /usr/local/tomcat/conf/server.xml

# Copy WAR đã build vào Tomcat (ROOT.war)
COPY build/VinfastSystem.war /usr/local/tomcat/webapps/ROOT.war

# Expose cổng nội bộ (8081)
EXPOSE 8081

CMD ["catalina.sh", "run"]
