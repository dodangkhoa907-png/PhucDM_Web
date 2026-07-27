# ============================================================================
# Eight Tea — build & chạy trên Tomcat 10.1 (bắt buộc: Jakarta Servlet 6.0
# trong pom.xml chỉ chạy được từ Tomcat 10.1 trở lên, KHÔNG chạy được Tomcat 9).
#
# Ứng dụng đọc cấu hình DB/mail/PayOS ưu tiên từ biến môi trường (xem
# Database.java, PayOSConfig.java) — image này KHÔNG chứa db.properties (file
# đó bị .gitignore chặn vì có mật khẩu thật, cũng không có trong Git nên dù
# muốn COPY vào cũng không COPY được). Khai báo biến môi trường ở nơi deploy,
# xem danh sách bắt buộc/tuỳ chọn trong README hoặc phần mô tả kèm theo.
# ============================================================================

# ── Stage 1: build WAR bằng Maven ──────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build

# Tách bước tải dependency ra layer riêng — chỉ chạy lại khi pom.xml đổi,
# không phải mỗi lần sửa 1 dòng Java.
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

COPY src ./src
RUN mvn -B -q clean package -DskipTests

# ── Stage 2: runtime — chỉ mang theo Tomcat + file .war, không mang theo Maven/JDK build tools ──
FROM tomcat:10.1-jdk17-temurin
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Deploy ở context root ("/") — khớp với cách các JSP dùng
# ${pageContext.request.contextPath} (rỗng ở root) cho mọi đường dẫn css/js/ảnh.
COPY --from=build /build/target/PhucDM_Web.war /usr/local/tomcat/webapps/ROOT.war

# Render (và phần lớn nền tảng PaaS Docker khác) cấp cổng lắng nghe qua biến
# môi trường PORT tại lúc chạy container, không cố định — entrypoint này sửa
# lại cổng HTTP connector trong server.xml đúng theo PORT trước khi khởi động.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]
