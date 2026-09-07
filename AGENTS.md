# AGENTS.md — Quy tắc dự án & Hướng dẫn dành cho AI Pair Programmer

## 1. Môi trường & Ràng buộc cốt lõi
- **Server:** Bắt buộc sử dụng **Apache Tomcat 11.0.4** (Jakarta Servlet 6.0). KHÔNG được hạ cấp về Tomcat 9 hay Tomcat 10 trừ khi có yêu cầu rõ ràng từ người dùng.
- **Sitemesh:** Bắt buộc sử dụng **SiteMesh 3** (`org.sitemesh:sitemesh:3.2.3`).
- **Namespace:** Tất cả Servlet, JSP, Mail, JPA, Validation đều phải dùng chuẩn `jakarta.*` (Ví dụ: `jakarta.servlet.*`, `jakarta.mail.*`, taglib `jakarta.tags.core`).
- **Git:** **TUYỆT ĐỐI KHÔNG** tự ý chạy `git push` lên GitHub nếu người dùng chưa kiểm tra kết quả và cho phép cụ thể.

---

## 2. Các quy tắc "Tránh vết xe đổ" (Lessons Learned & Anti-Patterns)

1. **Quy trình Đăng ký & OTP:**
   - **CẤM:** Không được gọi hàm `insert` / `register` vào Database trước khi OTP được người dùng xác thực.
   - **ĐÚNG:** Thông tin đăng ký phải lưu tạm vào `HttpSession` (`session.setAttribute(Constant.SESSION_PENDING_USER, user)`). Chỉ sau khi người dùng nhập đúng mã OTP tại `/verify-otp` thì mới mã hóa BCrypt và lưu vào Database.

2. **SiteMesh 3 trên Tomcat 11 (Vấn đề màn hình trắng 0 bytes):**
   - Không dùng bộ lọc SiteMesh nguyên bản một cách đơn thuần vì `RequestDispatcher.forward()` trên Tomcat 11 sẽ commit response stream sớm khiến SiteMesh bỏ qua buffer.
   - Luôn sử dụng bộ lọc tương thích: `org.sitemesh.config.ConfigurableSiteMeshFilter` trong `src/main/java/` (chuyển `forward` thành `include`, capture buffer bằng `CharResponseWrapper`, trang trí decorator và flush ra response).

3. **Response Wrappers:**
   - Luôn kế thừa trực tiếp từ `jakarta.servlet.http.HttpServletResponseWrapper`.
   - Không được dùng Dynamic Proxy (`Proxy.newProxyInstance`) để bọc response wrapper vì Tomcat 11 sẽ ném lỗi `ClassCastException`.

4. **Đồng bộ Tomcat khi build bằng Maven:**
   - Khi chạy độc lập ngoài IDE, binary được Tomcat nạp từ `tmp0\wtpwebapps\bt01`. Luôn đảm bảo đồng bộ `target/classes` sang `tmp0\wtpwebapps\bt01\WEB-INF/classes` nếu khởi động server bằng tay.

5. **Mật khẩu:**
   - Mọi mật khẩu người dùng phải được băm qua `PasswordUtil` bằng `BCrypt.hashpw(plainPassword, BCrypt.gensalt(12))`. Tuyệt đối không lưu plain text.

6. **Gọi Java Method trong JSP Expression Language (EL):**
   - **CẤM:** Không được gọi trực tiếp method Java dạng `${p.images.length()}`, `${p.images.startsWith('http')}`, `${!p.description.isEmpty()}` trong JSP. Trình biên dịch JSP của Tomcat/Eclipse sẽ báo lỗi `EL Syntax Error` hoặc không parse được.
   - **ĐÚNG:** Khai báo `<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>` và dùng hàm chuẩn `fn:startsWith(p.images, 'http')`, `fn:length(...)`, hoặc keyword EL `empty` / `not empty` (`<c:if test="${not empty p.description}">`).

7. **Kiểu dữ liệu trong JPA Entity / Model cho cột có thể NULL:**
   - **CẤM:** Tuyệt đối không dùng kiểu dữ liệu nguyên thủy (`boolean`, `int`, `long`, `double`) cho các thuộc tính Entity mà cột tương ứng trong Database cho phép `NULL`. Sẽ làm văng lỗi nghiêm trọng: `PropertyAccessException: Null value was assigned to a property [...] of primitive type`.
   - **ĐÚNG:** Luôn dùng kiểu đối tượng Wrapper (`Boolean`, `Integer`, `Long`, `Double`) cho các trường có khả năng mang giá trị `NULL`.

8. **Cơ chế DDL Auto của Hibernate trên Tomcat Runtime:**
   - **CẤM:** Không được chủ quan nghĩ rằng `hibernate.hbm2ddl.auto = update` trong `persistence.xml` sẽ tự động sinh bảng khi Tomcat vừa khởi động. Nếu không có trigger kết nối, Tomcat bật lên nhưng bảng DB chưa có, dẫn đến crash `Invalid object name '<table_name>'`.
   - **ĐÚNG:** Phải đảm bảo có `JpaListener` implements `ServletContextListener` kích hoạt `EntityManagerFactory` khi deploy, hoặc chủ động chạy file script SQL khởi tạo schema/seed data trước khi start ứng dụng.

9. **Hiển thị hình ảnh (URL Online vs File Upload cục bộ):**
   - **CẤM:** Không được đưa nguyên cả đường dẫn URL online (`http://...` hoặc `https://...`) vào servlet đọc file ảnh cục bộ dạng `/image?fname=http://...`.
   - **ĐÚNG:** Luôn phân nhánh kiểm tra bằng `<c:choose>`:
     - Nếu `fn:startsWith(img, 'http')`: render trực tiếp `<img src="${img}"/>`.
     - Nếu là tên file cục bộ: render `<img src="${pageContext.request.contextPath}/image?fname=${img}"/>`.

---

## 3. Chiến lược Kiểm thử Tối ưu (Tiết kiệm Thời gian & Token)
- **CẤM:** Không được tùy tiện chạy lại toàn bộ test suite (`mvn test`) sau mỗi thay đổi nhỏ (đặc biệt khi chỉ sửa JSP/CSS hoặc 1 dòng code logic). Chạy toàn bộ 38 test sẽ gửi email thật qua Brevo SMTP, tốn quota email, tốn thời gian build (~15s) và gây tràn token context vô ích.
- **ĐÚNG:**
  1. **Chế độ phát triển & Sửa nhanh:**
     - Nếu sửa logic 1 class: Chỉ chạy đúng test class đó:
       ```powershell
       mvn test -Dtest=TênClassTest
       ```
     - Nếu chỉ sửa JSP/CSS/Config và cần deploy thử: Build bỏ qua test:
       ```powershell
       mvn package -DskipTests
       ```
  2. **Khi nào MỚI chạy toàn bộ test (`mvn test`):**
     - Chỉ chạy toàn bộ test khi web gặp lỗi không rõ nguyên nhân cần kiểm tra hồi quy (regression test).
     - Hoặc trước khi nghiệm thu chốt phiên làm việc và có yêu cầu rõ ràng từ người dùng.

---

## 4. Quy trình Tự động Triển khai & Khởi động Tomcat 11
AI Agent có thể tự động 100% việc build, deploy và bật tắt Tomcat nền bằng các bước sau:

1. **Build WAR nhanh:**
   ```powershell
   mvn package -DskipTests
   ```
2. **Deploy vào Tomcat 11:**
   ```powershell
   Copy-Item "d:\DaiHoc\hk1-3\laptrinhweb\bt01\target\bt01-1.0.war" -Destination "D:\DaiHoc\hk1-3\laptrinhweb\apache-tomcat-11.0.4\webapps\bt01.war" -Force
   ```
3. **Khởi động Tomcat ngầm (Daemon):**
   ```powershell
   cmd.exe /c "scripts\start-tomcat.bat"
   ```
   *(Chạy qua `run_command` với cờ `IsDaemon: true` để không block terminal).*
4. **Kiểm chứng nhanh bằng curl.exe:**
   ```powershell
   curl.exe -i http://localhost:8080/bt01/login
   ```
   *(Xác nhận HTTP 200, Content-Length > 0, có HTML đầy đủ).*
5. **Dừng Tomcat khi xong việc:**
   ```powershell
   cmd.exe /c "scripts\stop-tomcat.bat"
   ```
