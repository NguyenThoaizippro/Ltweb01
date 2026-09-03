# Design: OTP Activation + Forgot Password + Product Module (bt01)

**Date:** 2026-09-03
**Status:** Approved
**Base:** bt01 Shopping Servlet MVC (Jakarta EE 6, Hibernate 7.4, SQL Server bt01, JSP JSTL)

---

## 1. Context & Constraints

- Nền móng giữ nguyên: `dbo.categories` (CategoryId,CategoryName,Images,status), `dbo.User` (id,email,username,...), `dbo.Videos` — không ALTER ngoài `User.isActive` (default 1 cho data cũ `admin@gmail.com`).
- Stack giữ nguyên: Maven WAR, Tomcat 10+, JDK 17, `pom.xml:10`, `persistence.xml:6` unit `jpa-hibernate-mysql`, upload `Constant.DIR=D:\upload`.
- Sender Brevo: `TOIDIBANHANG <thoain.n2006@gmail.com>` via `smtp-relay.brevo.com:587`, key `xsmtpsib-...-g2Mijuc9...` (không commit, để `.env`/env var).
- OTP: 6 số, expiry 120s, resend cooldown 60s, lưu DB `otp_tokens` (chọn B vì bền khi Tomcat restart, audit được, chi phí 1 bảng).
- Đăng ký: `username+email+password` → verify OTP mới `isActive=1` mới login.
- Forgot: nhập `email` → OTP → reset password.
- Product: 1-n với Category (FK `categoryId`), CRUD admin, Top10 ở `/home`, pagination `/product` 6sp/trang, detail `/product/detail?id=`.
- Upload: reuse `CategoryController.java:76` multipart `Part images1`, không tách thư mục.

---

## 2. Architecture

```
Browser → Servlet (@WebServlet) → Service → DAO → DB (JPA/Hibernate + JDBC)
                                ↘ EmailService (Jakarta Mail + Brevo SMTP)
JSP (views/*.jsp) ↔ Servlet (forward/redirect) ↔ Session/Cookie
```

- Giữ MVC hiện có. Thêm package: `entity/Product`, `entity/OtpToken`, `dao/ProductDao`, `service/ProductService`, `service/EmailService`, `util/OtpUtil`, `util/PasswordUtil`, `controller/RegisterController`, `controller/VerifyOtpController`, `controller/ForgotPasswordController`, `controller/ProductController`.
- Không thêm framework. Chỉ thêm deps: `jakarta.mail 2.0.1`, `jbcrypt 0.4`, `junit-jupiter 5.10`, `mockito 5.x`, `h2` (test).
- `JpaListener.java:8` auto `hbm2ddl.update` tạo `otp_tokens`, `products`.

---

## 3. Data Model

### 3.1 Nền giữ nguyên (không đụng)
- `categories` — y như `entity/Category.java:12`.
- `User` — y như `model/User.java:7`, chỉ thêm cột (nếu từ chối thì tách bảng `user_status`):
```sql
ALTER TABLE [User] ADD isActive BIT DEFAULT 1; -- existing admin =1, new register =0
```
- `Videos` — giữ nguyên.

### 3.2 Mới: otp_tokens
```sql
CREATE TABLE otp_tokens(
  id INT IDENTITY PRIMARY KEY,
  email NVARCHAR(100) NOT NULL,
  otp VARCHAR(6) NOT NULL,
  purpose VARCHAR(20) NOT NULL CHECK (purpose IN ('REGISTER','FORGOT')),
  createdAt DATETIME DEFAULT GETDATE(),
  expiresAt DATETIME NOT NULL,
  attempts INT DEFAULT 0
);
CREATE INDEX idx_otp_email_purpose ON otp_tokens(email,purpose);
```
Entity `OtpToken.java`: `@Entity @Table(name="otp_tokens")` field `id,email,otp,purpose,createdAt,expiresAt,attempts`, `@NamedQuery`.

### 3.3 Mới: products
```sql
CREATE TABLE products(
  productId INT IDENTITY PRIMARY KEY,
  productName NVARCHAR(200) NOT NULL,
  description NVARCHAR(1000),
  price DECIMAL(18,2) NOT NULL CHECK (price >=0),
  images NVARCHAR(500),
  status INT DEFAULT 1,
  createDate DATETIME DEFAULT GETDATE(),
  categoryId INT NOT NULL FOREIGN KEY REFERENCES categories(CategoryId)
);
CREATE INDEX idx_product_category ON products(categoryId);
CREATE INDEX idx_product_createDate ON products(createDate DESC);
```
Entity `Product.java`: `@Entity @Table(name="products")`, `@Id @GeneratedValue IDENTITY productId`, `@Column productName,description,price,images,status,createDate`, `@ManyToOne @JoinColumn(name="categoryId") Category category` (không thêm `@OneToMany` vào `Category.java` để giữ nền). `@NamedQuery` `Product.findAll`, `Product.findTop10`.

---

## 4. Components

### 4.1 OtpUtil & PasswordUtil
- `OtpUtil.generate6Digit()` — `SecureRandom 100000-999999`, `isExpired(expiresAt)`, `canResend(createdAt,60s)`.
- `PasswordUtil.hash(pw)` / `check(pw,hash)` — `BCrypt.hashpw` / `checkpw`.

### 4.2 EmailService
- `sendOtp(toEmail, otp, purpose)` — `jakarta.mail.Session` với `smtp-relay.brevo.com:587`, `auth apiKey:xSmtpsib`, `from=thoain.n2006@gmail.com`, `subject="[bt01] OTP ..."` , `body="Mã OTP 6 số: "+otp+" (hết hạn 120s)"`.
- Config đọc từ `brevo.properties` hoặc env `BREVO_API_KEY`, `MAIL_FROM` — không commit key.
- Interface để mock trong test.

### 4.3 DAO
- `OtpTokenDao` (JPA): `save(token)`, `findLatestByEmailAndPurpose(email,purpose)`, `deleteById`, `deleteExpired()`, `incrementAttempts()`.
- `ProductDao` (JPA, copy `CategoryDao.java:11`): `insert`, `update`, `delete`, `findById`, `findAll`, `findAll(page,pagesize)`, `findTopN(n)`, `findByCategory`, `searchByName`, `count`.
- `UserDao` mở rộng: `findByEmail(email)`, `findByUsername(username)`, `updateActive(id,1)`, `updatePassword(id,hash)` (JDBC `DBConnection.java:8`), đóng `conn/ps/rs` đúng.

### 4.4 Service
- `OtpService`: `createAndSend(email,purpose)` (check cooldown 60s → throw, generate otp, expiresAt+120s, save, send), `verify(email,otp,purpose)` (check tồn tại, expiry, attempts>3 → fail, so khớp → delete và return true).
- `UserService` mở rộng: `register(username,email,password)` (check unique username/email, hash, insert isActive=0, gọi OtpService), `activate(email)`, `login` sửa: check `isActive==0` → throw NotActivated, `BCrypt.check`, `forgotPassword(email)`, `resetPassword(email,newPw)`.
- `ProductService`: wrapper `ProductDao` + validate `category.exists`, `price>=0`.

### 4.5 Controllers

| URL | Class | Method | Mô tả |
|---|---|---|---|
| `GET /register` | `RegisterController` | doGet | forward `views/register.jsp` |
| `POST /register` | `RegisterController` | doPost | param username,email,password → `userService.register` → redirect `/verify-otp?email=&purpose=REGISTER` |
| `GET /verify-otp` | `VerifyOtpController` | doGet | forward `views/verify-otp.jsp` (hiển thị email, countdown 120s, nút resend disabled 60s) |
| `POST /verify-otp` | `VerifyOtpController` | doPost | param email,otp,purpose → `otpService.verify` → nếu REGISTER: `userService.activate` → redirect `/login?msg=activated`; nếu FORGOT: set session `resetEmail` → redirect `/reset-password` |
| `POST /resend-otp` | `VerifyOtpController` | doPost | `otpService.createAndSend` (check 60s) |
| `GET/POST /forgot-password` | `ForgotPasswordController` | doGet/doPost | GET form email, POST tạo OTP purpose FORGOT → redirect `/verify-otp?email=&purpose=FORGOT` |
| `GET/POST /reset-password` | `ForgotPasswordController` | doGet/doPost | check session resetEmail, POST newPassword+confirm → `userService.resetPassword` → clear session → redirect login |
| `GET /login` `POST /login` | `LoginController.java:17` sửa | — | thêm check `isActive`, dùng `PasswordUtil.check`, báo lỗi chi tiết |
| `/admin/products` etc | `ProductController` | — | `@WebServlet({/admin/products,/admin/product/add,/admin/product/insert,/admin/product/edit,/admin/product/update,/admin/product/delete})` CRUD y `CategoryController.java:24`, upload `Part images1` → `Constant.DIR` |
| `GET /home` | `HomeController.java:12` sửa | — | `productService.findTop10Newest()` → `setAttribute("top10")` → `home.jsp` grid |
| `GET /product` | `ProductController` | doGet | `?page=0` → `findAll(page,6)` + `count` → `views/product-list.jsp` phân trang |
| `GET /product/detail?id=` | `ProductController` | doGet | `findById` → `views/product-detail.jsp` |
| `GET /image?fname=` | `DownloadImageController.java:15` giữ nguyên | — | dùng chung cho product images |

### 4.6 JSP
- `register.jsp`, `verify-otp.jsp` (input 6 ô, countdown JS), `forgot-password.jsp`, `reset-password.jsp`, `admin/product-list.jsp` (copy `category-list.jsp:21` table + ảnh `/image?fname=`), `admin/product-add.jsp`, `admin/product-edit.jsp`, `product-list.jsp` (6sp/grid + phân trang), `product-detail.jsp`, sửa `home.jsp:10` thêm top10, sửa `login.jsp:17` thêm link `Đăng ký` `Quên mật khẩu`.

---

## 5. Flows

**Register+Activate:**
`register.jsp → POST /register → User isActive=0 + otp_tokens REGISTER + Email → verify-otp.jsp (120s) → POST /verify-otp → isActive=1 → /login`

**Login:**
`login.jsp → POST /login → find User → !isActive → "Chưa kích hoạt, check email" + resend → else BCrypt check → session.account → /waiting → role routing`

**Forgot:**
`/forgot-password (email) → otp FORGOT → verify-otp → /reset-password (newPw) → update hash → /login`

**Product:**
`admin/products → list → add (multipart) → insert → upload D:\upload → /image?fname= → edit/delete → /home top10, /product?page= pagination 6`

---

## 6. Error Handling & Security

- OTP: `expiresAt < now` → "OTP hết hạn", `attempts>=3` → xóa token bắt resend, `canResend` 60s → "Vui lòng đợi 60s".
- Không lộ email tồn tại: forgot luôn báo "Nếu email tồn tại đã gửi OTP" nhưng chỉ tạo token nếu email có.
- Password: BCrypt hash, không lưu plain, `UserDao` fix leak đóng `finally { rs.close(); ps.close(); conn.close(); }`.
- Upload: check `part.getSize()>0 && contentType in image/*`, `ext in jpg,jpeg,png,gif`, `size <=5MB`, `fname = System.currentTimeMillis()+ext`.
- Brevo key: đọc `System.getenv("BREVO_API_KEY")` fallback `brevo.properties` (gitignore), không hardcode.
- `persistence.xml` `hbm2ddl.auto=update` không xóa data cũ.

---

## 7. Testing Strategy (như tester thực thụ, TDD)

**Infra:** thêm vào `pom.xml`:
```xml
junit-jupiter 5.10.2, mockito-core 5.11, h2 2.2.224 (test scope), jakarta.mail 2.0.1, jbcrypt 0.4
```
Chạy `mvn test` pass mới sang task.

| Task | Test file | Case chính (phải pass) |
|---|---|---|
| OtpUtil | `OtpUtilTest` | 6 số, không trùng liên tiếp, isExpired 120s, canResend 60s |
| EmailService | `EmailServiceTest` | mock Transport, gửi đúng from/to/subject chứa OTP, không gửi khi email invalid |
| User register/login | `UserServiceTest` (H2) | register unique check, isActive=0, hash != plain, login chặn chưa active, login ok sau verify, duplicate email/username fail |
| Forgot | `ForgotPasswordTest` | tạo OTP FORGOT, verify sai 3 lần khóa, hết hạn fail, reset đổi hash và login lại được |
| ProductDao | `ProductDaoTest` (H2) | insert FK ok, insert FK sai fail, findTop10 đúng order, pagination 6/trang, searchByName, count |
| ProductController | `ProductControllerTest` (Mock HttpServletRequest/Response) | GET /product?page=0 trả 6sp, page out of range trả rỗng, detail 404 |
| Upload | `UploadTest` | multipart với file >5MB fail, sai ext fail, tên file unique |

**Verify lệnh mỗi task:** `mvn test -Dtest=XTest`, `mvn verify`, deploy `mvn clean package` + manual test trên Tomcat với `D:\upload` và Brevo test email.

---

## 8. Risks & Mitigations

- Brevo sender chưa verify → mail vào spam/test không tới: fallback log OTP ra console `System.out` khi `mail.debug=true` để tester vẫn lấy được OTP.
- `User` JDBC leak → fix đóng connection trong task đầu.
- `CategoryDao` leak `enma.close()` missing → fix khi thêm `ProductDao`.
- Ảnh upload `substring(0,5)` crash như `CategoryController.java:125` → fix check `startsWith("https")`.

---

## 9. Out of Scope (YAGNI)

- Không thêm role phân quyền chi tiết, admin xem hết như hiện trạng.
- Không tách `Constant.DIR` theo loại.
- Không thêm `@OneToMany` vào `Category.java`.
- Không thêm refresh token/JWT.

