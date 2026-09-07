# LESSONS.md — Tổng hợp lỗi sai, cách code cẩu thả & bài học kinh nghiệm

> File tra cứu nhanh (Quick Log) ghi lại các "vết xe đổ" thực tế đã gặp trong quá trình code dự án `bt01`, nguyên nhân kỹ thuật gốc rễ và cách phòng ngừa vĩnh viễn.

---

## Danh sách lỗi & Cách phòng ngừa (1-Liner Log)

- [2026-08-27] [web.xml/Tomcat 11] Khai báo sai schema Servlet cũ (`http://xmlns.jcp.org/...`) -> Đổi toàn bộ schema sang Jakarta EE 10 / Servlet 6.0 (`https://jakarta.ee/xml/ns/jakartaee` version `6.0`).
- [2026-08-27] [JPA/Tomcat Runtime] Nghĩ Hibernate `hbm2ddl.auto=update` tự tạo bảng trên Tomcat dẫn đến lỗi `Invalid object name 'categories'` -> Tạo `JpaListener` (@WebListener) kích hoạt `EntityManagerFactory` khi start server hoặc chạy script SQL khởi tạo bảng trước.
- [2026-08-27] [JSP/Taglib] Dùng sai URI taglib JSTL cũ (`http://java.sun.com/jsp/jstl/core`) -> Chuẩn hóa toàn bộ thành `jakarta.tags.core`, `jakarta.tags.functions`, `jakarta.tags.fmt`.
- [2026-09-03] [Auth/OTP] Gọi `userService.register()` lưu DB ngay tại form đăng ký ban đầu làm tồn tại tài khoản rác khi chưa nhập OTP -> Lưu tạm thông tin vào `HttpSession` (`SESSION_PENDING_USER`), chỉ `insert` vào DB sau khi xác thực OTP thành công tại `/verify-otp`.
- [2026-09-03] [JPA Entity] Khai báo kiểu nguyên thủy `boolean isActive`, `int status` cho cột DB cho phép `NULL` gây lỗi `PropertyAccessException: Null value was assigned to a property of primitive type` -> Luôn dùng Wrapper Class (`Boolean`, `Integer`, `Long`) cho mọi Entity field có thể `NULL` trong DB.
- [2026-09-03] [Email/Brevo] Lỗi SMTP không gửi được OTP hoặc ClassNotFound do cấu hình sai port/auth -> Dùng cổng TLS 587 (`mail.smtp.starttls.enable=true`, `mail.smtp.auth=true`), mật khẩu SMTP là Brevo Master API Key, dùng chuẩn `jakarta.mail`.
- [2026-09-03] [SiteMesh 3/Tomcat 11] `RequestDispatcher.forward()` trên Tomcat 11 kết thúc và commit socket sớm khiến SiteMesh bỏ qua buffer trả về màn hình trắng 0 bytes hoặc `Cannot forward after response has been committed` -> Cài `ConfigurableSiteMeshFilter` chuyển `forward` thành `include` và dùng `CharResponseWrapper` thuần bắt buffer HTML.
- [2026-09-03] [Servlet Response Wrapper] Dùng Dynamic Proxy (`Proxy.newProxyInstance`) bọc wrapper gây `ClassCastException: $Proxy cannot be cast to ServletResponseWrapper` -> Bắt buộc kế thừa trực tiếp từ `jakarta.servlet.http.HttpServletResponseWrapper`.
- [2026-09-03] [JSP/EL Syntax] Gọi method Java trực tiếp trong EL `${cate.images.length() >= 5}`, `${p.images.startsWith('http')}`, `${!p.description.isEmpty()}` gây `EL Syntax Error` trên Eclipse/Tomcat compiler -> Dùng thẻ hàm chuẩn `<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>` (`fn:startsWith`, `fn:length`) và toán tử `empty` / `not empty`.
- [2026-09-03] [Image Handling] Nhồi cả URL ảnh online `http://...` vào servlet đọc file `/image?fname=http...` gây vỡ ảnh trang chủ -> Dùng `<c:choose>` kiểm tra `fn:startsWith(img, 'http')`: nếu link online thì gắn trực tiếp vào `<img src="${img}">`, nếu upload thì mới qua `/image?fname=${img}`.
- [2026-09-04] [Deploy/Eclipse WTP] Sửa code và chạy `mvn test` ngoài terminal nhưng Eclipse/Tomcat chạy binary từ `tmp0\wtpwebapps` làm tưởng code chưa ăn -> Copy `target/classes` sang `tmp0\wtpwebapps\bt01\WEB-INF/classes` hoặc restart Tomcat sạch sẽ.
