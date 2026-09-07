# HƯỚNG DẪN TỰ CHẠY DỰ ÁN 100% BẰNG TAY (MANUAL GUIDE)

Tài liệu này hướng dẫn bạn tự tay gõ từng câu lệnh trong Terminal từ A đến Z: khởi động CSDL MySQL, đóng gói dự án Java Web bằng Maven, deploy vào Tomcat 11, khởi động server và mở web để kiểm thử.

---

## 0. Các đường dẫn quan trọng trên máy Mac của bạn

* **Thư mục dự án:** `/Users/nguyenthoai/DaiHoc/hk1-3/laptrinhweb/bt01`
* **Thư mục Tomcat 11:** `/Users/nguyenthoai/DaiHoc/hk1-3/laptrinhweb/apache-tomcat-11.0.4`
* **Đường dẫn Java JDK:** `/Library/Java/JavaVirtualMachines/temurin-26.jdk/Contents/Home`

---

## BƯỚC 1: Mở Terminal và thiết lập biến môi trường

Mở ứng dụng **Terminal** trên macOS và chạy 2 lệnh sau:

```bash
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-26.jdk/Contents/Home"
export CATALINA_HOME="/Users/nguyenthoai/DaiHoc/hk1-3/laptrinhweb/apache-tomcat-11.0.4"
```

> **Giải thích:** 2 lệnh này khai báo cho máy Mac biết Java phiên bản nào đang dùng và Tomcat 11 nằm ở thư mục nào.

---

## BƯỚC 2: Kiểm tra CSDL MySQL

Đảm bảo MySQL đang chạy ở cổng 3306:

```bash
brew services start mysql@8.4
```

> Nếu MySQL đã chạy rồi thì lệnh này sẽ báo trạng thái `already started`.

---

## BƯỚC 3: Đóng gói dự án Java Web thành file `.war` bằng Maven

Di chuyển vào thư mục dự án và chạy lệnh build:

```bash
cd /Users/nguyenthoai/DaiHoc/hk1-3/laptrinhweb/bt01
mvn clean package -DskipTests
```

> **Giải thích:**
> - `mvn clean`: Xóa thư mục build cũ `target/`.
> - `package`: Biên dịch toàn bộ mã nguồn Java, JSP và đóng gói thành file `target/bt01-1.0.war`.
> - `-DskipTests`: Bỏ qua chạy unit tests gửi email để tiết kiệm thời gian (chỉ mất ~2 giây).
> - Khi thấy dòng chữ **`BUILD SUCCESS`** màu xanh là đã đóng gói thành công!

---

## BƯỚC 4: Dừng Tomcat cũ và dọn dẹp thư mục webapps

Trước khi đưa code mới vào, bạn cần dừng Tomcat cũ (nếu có) và xóa bản deploy cũ:

```bash
# 1. Dừng Tomcat
$CATALINA_HOME/bin/shutdown.sh

# 2. Xóa bản deploy cũ trong Tomcat webapps
rm -rf $CATALINA_HOME/webapps/bt01
rm -f $CATALINA_HOME/webapps/bt01.war
```

---

## BƯỚC 5: Copy (Deploy) file `.war` mới vào Tomcat

Chạy lệnh copy file WAR vừa build vào thư mục `webapps` của Tomcat:

```bash
cp /Users/nguyenthoai/DaiHoc/hk1-3/laptrinhweb/bt01/target/bt01-1.0.war $CATALINA_HOME/webapps/bt01.war
```

---

## BƯỚC 6: Khởi động máy chủ Apache Tomcat 11

Gõ lệnh khởi động:

```bash
$CATALINA_HOME/bin/startup.sh
```

> Bạn sẽ thấy terminal báo: `Tomcat started.`

---

## BƯỚC 7: Xem log thời gian thực để biết Tomcat và Hibernate đã sẵn sàng

Để xem quá trình Tomcat giải nén file war và Hibernate tạo bảng trong MySQL, gõ:

```bash
tail -f $CATALINA_HOME/logs/catalina.out
```

* Khi bạn nhìn thấy dòng:
  ```text
  === [Hibernate] Auto-created/updated tables on Server Startup successfully! ===
  ... INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [xxxx] milliseconds
  ```
  nghĩa là ứng dụng đã chạy hoàn toàn ổn định!
* Bấm tổ hợp phím **`Ctrl + C`** để thoát khỏi màn hình xem log.

---

## BƯỚC 8: Mở trình duyệt và trải nghiệm

Mở trình duyệt (Safari / Chrome) và truy cập:

* **Trang Đăng nhập:** [http://localhost:8080/bt01/login](http://localhost:8080/bt01/login)
* **Trang Chủ:** [http://localhost:8080/bt01/home](http://localhost:8080/bt01/home)

### Tài khoản kiểm thử:
1. **Quản trị viên (Admin):**
   * Username: `admin`
   * Mật khẩu: `123456`
   * Đặc quyền: Vào được khu vực Quản trị `/admin/categories`, thêm/sửa/xóa danh mục, sản phẩm.
2. **Người dùng thông thường (User):**
   * Username: `user`
   * Mật khẩu: `123456`
   * Đặc quyền: Xem sản phẩm, cập nhật hồ sơ cá nhân `/profile`. Nếu cố tình gõ link `/admin/...` sẽ bị chặn và đưa về `/home`.

---

## BƯỚC 9: Dừng máy chủ Tomcat khi không sử dụng nữa

Khi bạn học xong hoặc muốn tắt server đi:

```bash
$CATALINA_HOME/bin/shutdown.sh
```

---

## TỔNG KẾT: Danh sách lệnh rút gọn (Copy-Paste nhanh)

Khi bạn đã quen, mỗi lần muốn sửa code xong và deploy lại, bạn chỉ cần mở Terminal và copy 1 khối lệnh duy nhất này:

```bash
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-26.jdk/Contents/Home"
export CATALINA_HOME="/Users/nguyenthoai/DaiHoc/hk1-3/laptrinhweb/apache-tomcat-11.0.4"
cd /Users/nguyenthoai/DaiHoc/hk1-3/laptrinhweb/bt01
mvn clean package -DskipTests
$CATALINA_HOME/bin/shutdown.sh 2>/dev/null || true
rm -rf $CATALINA_HOME/webapps/bt01*
cp target/bt01-1.0.war $CATALINA_HOME/webapps/bt01.war
$CATALINA_HOME/bin/startup.sh
echo "Đã khởi động Tomcat thành công! Đang mở web..."
open http://localhost:8080/bt01/login
```
