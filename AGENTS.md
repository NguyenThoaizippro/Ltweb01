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

---

## 3. Kiểm tra chất lượng trước khi hoàn thành
- Luôn chạy kiểm thử:
  ```powershell
  mvn test
  ```
  Phải đảm bảo tất cả tests đều PASS (0 Failures, 0 Errors).
- Trước khi báo xong cho người dùng, hãy dùng `curl` để kiểm tra trang đích có trả về HTTP 200 kèm `Content-Length > 0` và nội dung HTML hoàn chỉnh hay không.
