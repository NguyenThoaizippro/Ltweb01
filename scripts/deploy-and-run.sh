#!/bin/bash
set -e

# Xác định thư mục dự án
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TOMCAT_DIR="/Users/nguyenthoai/DaiHoc/hk1-3/laptrinhweb/apache-tomcat-11.0.4"
JAVA_HOME_PATH="/Library/Java/JavaVirtualMachines/temurin-26.jdk/Contents/Home"

export JAVA_HOME="$JAVA_HOME_PATH"
export CATALINA_HOME="$TOMCAT_DIR"

echo "========================================================"
echo "🚀 [1/5] Đang đóng gói dự án bằng Maven (skip tests)..."
echo "========================================================"
cd "$PROJECT_DIR"
mvn package -DskipTests

echo ""
echo "========================================================"
echo "🛑 [2/5] Đang dừng Tomcat (nếu đang chạy)..."
echo "========================================================"
"$SCRIPT_DIR/stop-tomcat.sh" > /dev/null 2>&1 || true
sleep 2

# Đảm bảo tiến trình cũ đã dừng hẳn
pkill -f "apache-tomcat-11.0.4" > /dev/null 2>&1 || true

echo ""
echo "========================================================"
echo "📦 [3/5] Đang deploy file WAR vào Tomcat webapps..."
echo "========================================================"
rm -rf "$TOMCAT_DIR/webapps/bt01"
rm -f "$TOMCAT_DIR/webapps/bt01.war"
cp "$PROJECT_DIR/target/bt01-1.0.war" "$TOMCAT_DIR/webapps/bt01.war"

echo ""
echo "========================================================"
echo "🌟 [4/5] Đang khởi động máy chủ Tomcat 11..."
echo "========================================================"
"$SCRIPT_DIR/start-tomcat.sh"

echo ""
echo "========================================================"
echo "⏳ [5/5] Đang kiểm tra kết nối ứng dụng (chờ 3 giây)..."
echo "========================================================"
sleep 3

STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/bt01/login || echo "000")
if [ "$STATUS_CODE" -eq 200 ] || [ "$STATUS_CODE" -eq 302 ]; then
    echo "✅ Máy chủ đã chạy thành công! (Mã phản hồi HTTP: $STATUS_CODE)"
    echo "🌐 Đang mở trình duyệt vào trang đăng nhập..."
    open "http://localhost:8080/bt01/login"
else
    echo "⚠️ Tomcat đang khởi động nhưng chưa phản hồi ngay (HTTP $STATUS_CODE). Vui lòng thử truy cập:"
    echo "👉 http://localhost:8080/bt01/login"
fi

echo ""
echo "========================================================"
echo "🎉 HOÀN TẤT! Bạn có thể tự do test các tính năng."
echo "========================================================"
