#!/bin/sh
# Render (và các nền tảng PaaS Docker tương tự) chỉ định cổng HTTP thật qua biến
# môi trường PORT tại lúc container khởi động — không cố định trước, nên không thể
# hardcode trong server.xml lúc build image. Ghi đè cổng Connector HTTP mặc định
# (8080) ngay trước khi Tomcat start. Mặc định về 8080 nếu chạy local không set PORT
# (vd. `docker run -p 8080:8080 eight-tea`).
set -e

PORT="${PORT:-8080}"
sed -i "s/port=\"8080\"/port=\"${PORT}\"/" /usr/local/tomcat/conf/server.xml

exec "$@"
