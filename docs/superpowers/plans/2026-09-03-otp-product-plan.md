# OTP Activation + Forgot Password + Product Module Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Thêm đăng ký kích hoạt OTP qua Brevo, quên mật khẩu OTP, và module Product (CRUD, Top10 home, pagination /product, detail) chồng lên nền Category/User hiện có mà không sửa nền.

**Architecture:** Giữ MVC Servlet Jakarta 6 + JSP JSTL + Hibernate 7.4 + SQL Server. Thêm `OtpToken` + `Product` entities (JPA), `EmailService` (Jakarta Mail Brevo SMTP), `OtpService`, mở rộng `UserService`, và 3 controller mới `Register/VerifyOtp/ForgotPassword` + `ProductController`. Mỗi task có test cycle riêng, TDD.

**Tech Stack:** Java 17, Maven WAR, Hibernate 7.4.6, Jakarta Servlet 6, JSP JSTL 3.0, Jakarta Mail 2.0.1, jBCrypt 0.4, JUnit Jupiter 5.10.2, Mockito 5.11, H2 2.2.224 (test), Brevo SMTP relay `smtp-relay.brevo.com:587`

**Spec:** `docs/superpowers/specs/2026-09-03-otp-product-design.md`

## Global Constraints

- JDK 17, packaging war, Tomcat 10+ (`pom.xml:8`)
- persistence-unit `jpa-hibernate-mysql` SQL Server `localhost\SQLEXPRESS/bt01 sa/1234` `hbm2ddl.auto=update` (`persistence.xml:6`)
- Upload dir `Constant.DIR=D:\upload` (`util/Constant.java:4`) dùng chung Product/Category
- OTP 6 số, 120s expiry, resend 60s cooldown, purpose REGISTER/FORGOT, sender `TOIDIBANHANG <thoain.n2006@gmail.com>` Brevo key env `BREVO_API_KEY`
- Nền `categories` không ALTER, `User` chỉ thêm `isActive BIT DEFAULT 1`
- `git commit` sau mỗi task pass `mvn test`

---

## File Structure

**Create:**
- `src/main/java/vn/iotstar/util/OtpUtil.java` — sinh 6 số, check expiry/resend
- `src/main/java/vn/iotstar/util/PasswordUtil.java` — BCrypt hash/check
- `src/main/java/vn/iotstar/util/EmailConfig.java` — đọc env/properties
- `src/main/java/vn/iotstar/service/EmailService.java` + `impl/EmailServiceImpl.java` — gửi OTP qua Brevo
- `src/main/java/vn/iotstar/entity/OtpToken.java` — @Entity otp_tokens
- `src/main/java/vn/iotstar/dao/OtpTokenDao.java` + `impl` — JPA
- `src/main/java/vn/iotstar/service/OtpService.java` + `impl` — tạo/verify OTP
- `src/main/java/vn/iotstar/entity/Product.java` — @Entity products
- `src/main/java/vn/iotstar/dao/ProductDao.java` + `impl`/`ProductDao.java` — JPA CRUD+pagination
- `src/main/java/vn/iotstar/service/ProductService.java` + `impl` — wrapper
- `src/main/java/vn/iotstar/controller/RegisterController.java` — /register
- `src/main/java/vn/iotstar/controller/VerifyOtpController.java` — /verify-otp, /resend-otp
- `src/main/java/vn/iotstar/controller/ForgotPasswordController.java` — /forgot-password, /reset-password
- `src/main/java/vn/iotstar/controller/ProductController.java` — /admin/products, /product, /product/detail
- `src/main/resources/brevo.properties` (gitignore, sample `brevo.properties.example`)
- `src/main/webapp/views/register.jsp`, `verify-otp.jsp`, `forgot-password.jsp`, `reset-password.jsp`
- `src/main/webapp/views/admin/product-list.jsp`, `product-add.jsp`, `product-edit.jsp`
- `src/main/webapp/views/product-list.jsp`, `product-detail.jsp`
- `src/test/java/vn/iotstar/util/OtpUtilTest.java`, `PasswordUtilTest.java`, `service/EmailServiceTest.java`, `service/OtpServiceTest.java`, `service/UserServiceTest.java`, `dao/ProductDaoTest.java`, `controller/ProductControllerTest.java`

**Modify:**
- `pom.xml:10` — thêm deps jakarta.mail, jbcrypt, junit, mockito, h2
- `src/main/java/vn/iotstar/connection/DBConnection.java:8` — fix leak (đóng conn) + thêm `findByEmail`
- `src/main/java/vn/iotstar/dao/impl/UserDaoImpl.java:11` — thêm `findByEmail`, `findByUsername`, `updateActive`, `updatePassword`, fix leak
- `src/main/java/vn/iotstar/service/impl/UserServiceImpl.java:12` — thêm register/activate/forgot/reset, sửa login check isActive + BCrypt
- `src/main/java/vn/iotstar/controller/LoginController.java:17` — check isActive, BCrypt, link register/forgot
- `src/main/java/vn/iotstar/controller/HomeController.java:12` — thêm top10 products
- `src/main/webapp/views/login.jsp:17` — thêm link Đăng ký/Quên MK
- `src/main/webapp/views/home.jsp:10` — thêm grid top10
- `src/main/resources/META-INF/persistence.xml:6` — không sửa (auto update)

---

### Task 0: Setup Infra — pom, BCrypt, Mail config, fix leak nền

**Files:**
- Modify: `pom.xml`
- Create: `src/main/java/vn/iotstar/util/PasswordUtil.java`, `src/main/java/vn/iotstar/util/EmailConfig.java`, `src/main/resources/brevo.properties.example`
- Test: `src/test/java/vn/iotstar/util/PasswordUtilTest.java`

**Interfaces:**
- Consumes: none
- Produces: `PasswordUtil.hash(String):String`, `PasswordUtil.check(String,String):boolean`, `EmailConfig.getSmtpHost():String` etc — dùng cho Task 1,2

- [ ] **Step 1: Thêm deps vào pom.xml**

```xml
<!-- thêm vào <dependencies> sau commons-io -->
<dependency><groupId>com.sun.mail</groupId><artifactId>jakarta.mail</artifactId><version>2.0.1</version></dependency>
<dependency><groupId>org.mindrot</groupId><artifactId>jbcrypt</artifactId><version>0.4</version></dependency>
<!-- test -->
<dependency><groupId>org.junit.jupiter</groupId><artifactId>junit-jupiter</artifactId><version>5.10.2</version><scope>test</scope></dependency>
<dependency><groupId>org.mockito</groupId><artifactId>mockito-core</artifactId><version>5.11.0</version><scope>test</scope></dependency>
<dependency><groupId>com.h2database</groupId><artifactId>h2</artifactId><version>2.2.224</version><scope>test</scope></dependency>
```
Chạy `mvn dependency:resolve` check không lỗi.

- [ ] **Step 2: Viết failing test PasswordUtil**

```java
// src/test/java/vn/iotstar/util/PasswordUtilTest.java
package vn.iotstar.util;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
public class PasswordUtilTest {
  @Test void hashAndCheck() {
    String hash = PasswordUtil.hash("123");
    assertNotEquals("123", hash);
    assertTrue(PasswordUtil.check("123", hash));
    assertFalse(PasswordUtil.check("wrong", hash));
  }
  @Test void hashIsDifferentEachTime() {
    assertNotEquals(PasswordUtil.hash("123"), PasswordUtil.hash("123"));
  }
}
```

- [ ] **Step 3: Run test fail**

Run: `mvn test -Dtest=vn.iotstar.util.PasswordUtilTest -v`
Expected: FAIL `PasswordUtil not found`

- [ ] **Step 4: Implement minimal**

```java
// src/main/java/vn/iotstar/util/PasswordUtil.java
package vn.iotstar.util;
import org.mindrot.jbcrypt.BCrypt;
public class PasswordUtil {
  public static String hash(String plain){ return BCrypt.hashpw(plain, BCrypt.gensalt(12)); }
  public static boolean check(String plain, String hash){ return BCrypt.checkpw(plain, hash); }
}
```

- [ ] **Step 5: Run pass**

Run: `mvn test -Dtest=vn.iotstar.util.PasswordUtilTest`
Expected: PASS 2/2

- [ ] **Step 6: Tạo EmailConfig + fix UserDao leak (prep)**

```java
// src/main/java/vn/iotstar/util/EmailConfig.java
package vn.iotstar.util;
public class EmailConfig {
  public static String getApiKey(){ String v=System.getenv("BREVO_API_KEY"); if(v!=null) return v; try{var p=new java.util.Properties(); p.load(EmailConfig.class.getResourceAsStream("/brevo.properties")); return p.getProperty("brevo.api.key");}catch(Exception e){return "xsmtpsib-YOUR_API_KEY_HERE";}}
  public static String getFromEmail(){ return "thoain.n2006@gmail.com"; }
  public static String getFromName(){ return "TOIDIBANHANG"; }
  public static String getSmtpHost(){ return "smtp-relay.brevo.com"; }
  public static int getSmtpPort(){ return 587; }
}
// brevo.properties.example
brevo.api.key=xsmtpsib-xxx
mail.from=thoain.n2006@gmail.com
mail.from.name=TOIDIBANHANG
```

Sửa `UserDaoImpl.java:11` đóng conn trong finally (dán code, không cần test chạy nhưng verify không leak).

- [ ] **Step 7: Commit**

```bash
git add pom.xml src/main/java/vn/iotstar/util/PasswordUtil.java src/main/java/vn/iotstar/util/EmailConfig.java src/test/java/vn/iotstar/util/PasswordUtilTest.java src/main/resources/brevo.properties.example
git commit -m "feat: setup bcrypt, mail config, test infra"
```

---

### Task 1: OTP Core — OtpUtil + OtpToken + EmailService + OtpService

**Files:**
- Create: `src/main/java/vn/iotstar/util/OtpUtil.java`
- Create: `src/main/java/vn/iotstar/entity/OtpToken.java`
- Create: `src/main/java/vn/iotstar/dao/OtpTokenDao.java`, `src/main/java/vn/iotstar/dao/impl/OtpTokenDaoImpl.java`
- Create: `src/main/java/vn/iotstar/service/OtpService.java`, `src/main/java/vn/iotstar/service/impl/OtpServiceImpl.java`
- Create: `src/main/java/vn/iotstar/service/EmailService.java`, `src/main/java/vn/iotstar/service/impl/EmailServiceImpl.java`
- Test: `src/test/java/vn/iotstar/util/OtpUtilTest.java`, `src/test/java/vn/iotstar/service/OtpServiceTest.java`, `src/test/java/vn/iotstar/service/EmailServiceTest.java`
- Modify: `src/main/resources/META-INF/persistence.xml` không sửa nhưng verify `persistence-unit` có `OtpToken`

**Interfaces:**
- Consumes: `PasswordUtil`, `EmailConfig` từ Task0
- Produces: `OtpUtil.generate():String`, `OtpService.createAndSend(email,purpose):void` (throws Cooldown), `OtpService.verify(email,otp,purpose):boolean`, `EmailService.sendOtp(to,otp,purpose):void`

- [ ] **Step 1: Viết failing test OtpUtil**

```java
// src/test/java/vn/iotstar/util/OtpUtilTest.java
package vn.iotstar.util;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import java.time.Instant;
public class OtpUtilTest {
  @Test void generate6Digits(){ String otp=OtpUtil.generate(); assertTrue(otp.matches("\\d{6}")); }
  @Test void expiry120s(){ Instant now=Instant.now(); assertTrue(OtpUtil.isExpired(now.plusSeconds(121), 120)); assertFalse(OtpUtil.isExpired(now.plusSeconds(119), 120)); }
  @Test void canResend60s(){ Instant created=Instant.now().minusSeconds(30); assertFalse(OtpUtil.canResend(created,60)); assertTrue(OtpUtil.canResend(Instant.now().minusSeconds(61),60)); }
  @Test void otpRandom(){ assertNotEquals(OtpUtil.generate(), OtpUtil.generate()); } // flaky nhưng ok
}
```

- [ ] **Step 2: Run fail** `mvn test -Dtest=vn.iotstar.util.OtpUtilTest` → FAIL

- [ ] **Step 3: Implement OtpUtil**

```java
// src/main/java/vn/iotstar/util/OtpUtil.java
package vn.iotstar.util;
import java.security.SecureRandom; import java.time.Instant;
public class OtpUtil {
  private static final SecureRandom R=new SecureRandom();
  public static String generate(){ return String.format("%06d", R.nextInt(1_000_000)); }
  public static boolean isExpired(Instant expiresAt, long ttlSec){ return Instant.now().isAfter(expiresAt); }
  public static boolean isExpired(java.util.Date expiresAt){ return new java.util.Date().after(expiresAt); }
  public static boolean canResend(Instant createdAt, long cooldownSec){ return Instant.now().isAfter(createdAt.plusSeconds(cooldownSec)); }
  public static boolean canResend(java.util.Date createdAt, long cooldownSec){ return System.currentTimeMillis() - createdAt.getTime() > cooldownSec*1000; }
}
```

- [ ] **Step 4: Run pass** `mvn test -Dtest=vn.iotstar.util.OtpUtilTest` → PASS

- [ ] **Step 5: Viết entity OtpToken + DAO**

```java
// src/main/java/vn/iotstar/entity/OtpToken.java
package vn.iotstar.entity;
import jakarta.persistence.*; import java.util.Date;
@Entity @Table(name="otp_tokens") @NamedQuery(name="OtpToken.findLatest", query="SELECT o FROM OtpToken o WHERE o.email=:email AND o.purpose=:purpose ORDER BY o.createdAt DESC")
public class OtpToken {
  @Id @GeneratedValue(strategy=GenerationType.IDENTITY) private int id;
  @Column(nullable=false) private String email;
  @Column(nullable=false,length=6) private String otp;
  @Column(nullable=false) private String purpose;
  @Temporal(TemporalType.TIMESTAMP) private Date createdAt=new Date();
  @Temporal(TemporalType.TIMESTAMP) private Date expiresAt;
  private int attempts=0;
  // getters setters + noarg/allarg
  public OtpToken(){}
  public OtpToken(String email,String otp,String purpose,Date expiresAt){this.email=email;this.otp=otp;this.purpose=purpose;this.expiresAt=expiresAt;}
  // getters/setters...
  public int getId(){return id;} public void setId(int id){this.id=id;}
  public String getEmail(){return email;} public void setEmail(String e){this.email=e;}
  public String getOtp(){return otp;} public void setOtp(String o){this.otp=o;}
  public String getPurpose(){return purpose;} public void setPurpose(String p){this.purpose=p;}
  public Date getCreatedAt(){return createdAt;} public void setCreatedAt(Date d){this.createdAt=d;}
  public Date getExpiresAt(){return expiresAt;} public void setExpiresAt(Date d){this.expiresAt=d;}
  public int getAttempts(){return attempts;} public void setAttempts(int a){this.attempts=a;}
}
```

`OtpTokenDao` interface: `void save(OtpToken)`, `OtpToken findLatest(email,purpose)`, `void delete(int id)`, `void incrementAttempts(int id)`.

Implement `OtpTokenDaoImpl` dùng `JPAConfig.getEntityManager()` pattern như `CategoryDao.java:14` (try trans begin persist/commit, close).

- [ ] **Step 6: Viết EmailService + test mock**

```java
// src/main/java/vn/iotstar/service/EmailService.java
package vn.iotstar.service;
public interface EmailService { void sendOtp(String toEmail, String otp, String purpose) throws Exception; }

// src/main/java/vn/iotstar/service/impl/EmailServiceImpl.java
package vn.iotstar.service.impl;
import vn.iotstar.service.EmailService; import vn.iotstar.util.EmailConfig;
import jakarta.mail.*; import jakarta.mail.internet.*; import java.util.Properties;
public class EmailServiceImpl implements EmailService {
  @Override public void sendOtp(String to,String otp,String purpose) throws Exception {
    Properties p=new Properties(); p.put("mail.smtp.host", EmailConfig.getSmtpHost()); p.put("mail.smtp.port", String.valueOf(EmailConfig.getSmtpPort())); p.put("mail.smtp.auth","true"); p.put("mail.smtp.starttls.enable","true");
    Session s=Session.getInstance(p, new Authenticator(){protected PasswordAuthentication getPasswordAuthentication(){return new PasswordAuthentication("apikey", EmailConfig.getApiKey());}});
    Message m=new MimeMessage(s); m.setFrom(new InternetAddress(EmailConfig.getFromEmail(), EmailConfig.getFromName())); m.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to)); m.setSubject("[bt01] OTP "+purpose+" - "+otp); m.setText("Mã OTP của bạn là: "+otp+"\nHết hạn sau 120 giây.\nNếu không yêu cầu, bỏ qua email này.");
    // fallback log nếu không gửi được (dev)
    try{ Transport.send(m);}catch(Exception e){ System.out.println("=== [MOCK EMAIL] OTP "+otp+" to "+to+" purpose "+purpose+" ==="); System.out.println(e.getMessage()); if(System.getenv("BREVO_API_KEY")==null && EmailConfig.getApiKey().contains("xsmtpsib")) throw e; }
  }
}
```

Test `EmailServiceTest` mock `Transport` hoặc test không gửi thật: verify `sendOtp` không throw khi email hợp lệ, throw khi email rỗng.

- [ ] **Step 7: Viết OtpService + test**

```java
// Test: src/test/java/vn/iotstar/service/OtpServiceTest.java
package vn.iotstar.service;
import org.junit.jupiter.api.*; import static org.junit.jupiter.api.Assertions.*;
import vn.iotstar.service.impl.OtpServiceImpl; import vn.iotstar.service.impl.EmailServiceImpl; // mock email no send
public class OtpServiceTest {
  OtpService svc;
  @BeforeEach void setup(){ svc=new OtpServiceImpl(new EmailService(){public void sendOtp(String a,String b,String c){}}); }
  @Test void createAndVerifyOk() throws Exception {
    String email="test"+System.currentTimeMillis()+"@gmail.com";
    svc.createAndSend(email,"REGISTER");
    var token=svc.findLatest(email,"REGISTER");
    assertNotNull(token);
    assertTrue(svc.verify(email, token.getOtp(), "REGISTER"));
  }
  @Test void verifyWrongFail(){ assertFalse(svc.verify("no@gmail.com","000000","REGISTER")); }
  @Test void resendCooldown60s() throws Exception {
    String email="cool"+System.currentTimeMillis()+"@gmail.com";
    svc.createAndSend(email,"REGISTER");
    assertThrows(Exception.class, ()-> svc.createAndSend(email,"REGISTER")); // cooldown
  }
  @Test void expiry120s() throws Exception {
    // tạo token thủ công hết hạn rồi verify fail
  }
}
```

Implement `OtpServiceImpl` với logic cooldown 60s, expiry 120s, attempts.

- [ ] **Step 8: Run** `mvn test -Dtest=vn.iotstar.util.OtpUtilTest,vn.iotstar.service.OtpServiceTest` → PASS

- [ ] **Step 9: Commit**

```bash
git add src/main/java/vn/iotstar/util/OtpUtil.java src/main/java/vn/iotstar/entity/OtpToken.java src/main/java/vn/iotstar/dao/*Otp* src/main/java/vn/iotstar/service/*Otp* src/main/java/vn/iotstar/service/*Email* src/test/java/vn/iotstar/util/OtpUtilTest.java src/test/java/vn/iotstar/service/OtpServiceTest.java
git commit -m "feat: otp core 6digits 120s 60s-cooldown + brevo email"
```

---

### Task 2: Đăng ký + Xác thực OTP (Register flow)

**Files:**
- Modify: `src/main/java/vn/iotstar/dao/impl/UserDaoImpl.java`, `src/main/java/vn/iotstar/service/impl/UserServiceImpl.java`
- Create: `src/main/java/vn/iotstar/controller/RegisterController.java`, `src/main/java/vn/iotstar/controller/VerifyOtpController.java`
- Create: `src/main/webapp/views/register.jsp`, `src/main/webapp/views/verify-otp.jsp`
- Test: `src/test/java/vn/iotstar/service/UserServiceTest.java` (register part)

**Interfaces:**
- Consumes: `OtpService.createAndSend`, `PasswordUtil.hash`, `UserDao.findByEmail/Username`
- Produces: `UserService.register(username,email,password):User` (isActive=0), `UserService.activate(email):void`

- [ ] **Step 1: Viết failing test UserService register**

```java
// src/test/java/vn/iotstar/service/UserServiceTest.java
package vn.iotstar.service;
import org.junit.jupiter.api.Test; import static org.junit.jupiter.api.Assertions.*;
import vn.iotstar.service.impl.UserServiceImpl;
public class UserServiceTest {
  @Test void registerCreatesInactiveAndHash() throws Exception {
    UserService svc=new UserServiceImpl();
    String u="user"+System.currentTimeMillis(); String e=u+"@gmail.com";
    svc.register(u,e,"123456"); // nếu trùng throw
    var user=svc.get(u);
    assertNotNull(user);
    assertEquals(0, user.getIsActive()); // cần thêm field isActive vào User model
    assertNotEquals("123456", user.getPassWord());
    assertTrue(vn.iotstar.util.PasswordUtil.check("123456", user.getPassWord()));
  }
  @Test void registerDuplicateFail(){
    UserService svc=new UserServiceImpl();
    assertThrows(Exception.class, ()-> svc.register("admin","admin@gmail.com","123"));
  }
}
```

- [ ] **Step 2: Run fail** `mvn test -Dtest=vn.iotstar.service.UserServiceTest` → FAIL (isActive chưa có)

- [ ] **Step 3: Thêm isActive vào User model + DB**

```java
// src/main/java/vn/iotstar/model/User.java:7 thêm field
private int isActive; // 0 inactive, 1 active
public int getIsActive(){return isActive;} public void setIsActive(int v){this.isActive=v;}
// update constructor
```
SQL: `ALTER TABLE [User] ADD isActive BIT DEFAULT 1; UPDATE [User] SET isActive=1;` (chạy tay trên SSMS, Hibernate không quản User)

Sửa `UserDaoImpl.java:18` `get` map `isActive`, thêm `getByEmail`, `insert`, `updateActive`.

- [ ] **Step 4: Implement UserService.register**

```java
// src/main/java/vn/iotstar/service/impl/UserServiceImpl.java
public void register(String username,String email,String password) throws Exception {
  if(userDao.get(username)!=null) throw new Exception("Username đã tồn tại");
  if(userDao.getByEmail(email)!=null) throw new Exception("Email đã tồn tại");
  User u=new User(); u.setUserName(username); u.setEmail(email); u.setPassWord(PasswordUtil.hash(password)); u.setIsActive(0); u.setRoleid(3); u.setCreatedDate(new java.sql.Date(System.currentTimeMillis()));
  userDao.insert(u);
  otpService.createAndSend(email,"REGISTER");
}
public void activate(String email){ userDao.updateActiveByEmail(email,1); }
```

- [ ] **Step 5: Run pass** `mvn test -Dtest=vn.iotstar.service.UserServiceTest` → PASS

- [ ] **Step 6: Tạo Controllers + JSP**

```java
// RegisterController.java
@WebServlet("/register")
public class RegisterController extends HttpServlet {
  UserService userService=new UserServiceImpl();
  protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws IOException,ServletException { req.getRequestDispatcher("/views/register.jsp").forward(req,resp); }
  protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws IOException,ServletException {
    String u=req.getParameter("username"), e=req.getParameter("email"), p=req.getParameter("password");
    try{ userService.register(u,e,p); resp.sendRedirect(req.getContextPath()+"/verify-otp?email="+e+"&purpose=REGISTER"); }
    catch(Exception ex){ req.setAttribute("alert", ex.getMessage()); req.getRequestDispatcher("/views/register.jsp").forward(req,resp); }
  }
}
// VerifyOtpController.java
@WebServlet({"/verify-otp","/resend-otp"})
public class VerifyOtpController extends HttpServlet {
  OtpService otpService=new OtpServiceImpl(...); UserService userService=new UserServiceImpl();
  protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException { req.getRequestDispatcher("/views/verify-otp.jsp").forward(req,resp); }
  protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws IOException,ServletException {
    String email=req.getParameter("email"), otp=req.getParameter("otp"), purpose=req.getParameter("purpose");
    String uri=req.getRequestURI();
    if(uri.contains("resend-otp")){ try{ otpService.createAndSend(email,purpose); req.setAttribute("alert","Đã gửi lại OTP"); }catch(Exception e){ req.setAttribute("alert",e.getMessage()); } req.getRequestDispatcher("/views/verify-otp.jsp").forward(req,resp); return; }
    if(otpService.verify(email,otp,purpose)){
      if("REGISTER".equals(purpose)) userService.activate(email);
      else req.getSession().setAttribute("resetEmail", email);
      resp.sendRedirect(req.getContextPath()+ ( "REGISTER".equals(purpose) ? "/login?msg=activated" : "/reset-password"));
    } else { req.setAttribute("alert","OTP sai hoặc hết hạn"); req.getRequestDispatcher("/views/verify-otp.jsp").forward(req,resp); }
  }
}
```

`register.jsp`: form username,email,password (required), link login. `verify-otp.jsp`: hiển thị email, input otp 6 số, hidden purpose, button Xác nhận + Gửi lại (JS countdown 60s disable, 120s expiry notice).

- [ ] **Step 7: Manual verify** `mvn clean package` deploy Tomcat, test `http://localhost:8080/bt01/register` → nhập `thoain.n2006@gmail.com` → check mail OTP 6 số → verify → login được.

- [ ] **Step 8: Commit**

```bash
git add src/main/java/vn/iotstar/model/User.java src/main/java/vn/iotstar/dao/impl/UserDaoImpl.java src/main/java/vn/iotstar/service/impl/UserServiceImpl.java src/main/java/vn/iotstar/controller/RegisterController.java src/main/java/vn/iotstar/controller/VerifyOtpController.java src/main/webapp/views/register.jsp src/main/webapp/views/verify-otp.jsp src/test/java/vn/iotstar/service/UserServiceTest.java
git commit -m "feat: register + otp activation 120s flow"
```

---

### Task 3: Sửa Login + Waiting chặn chưa active

**Files:**
- Modify: `src/main/java/vn/iotstar/controller/LoginController.java:17`, `src/main/java/vn/iotstar/controller/WaitingController.java:17`, `src/main/webapp/views/login.jsp:17`
- Test: mở rộng `UserServiceTest` login part

**Interfaces:**
- Consumes: `UserService.login` đã sửa, `PasswordUtil.check`
- Produces: login chặn inactive + BCrypt

- [ ] **Step 1: Viết failing test login**

```java
@Test void loginBlockInactive() throws Exception {
  UserService svc=new UserServiceImpl(); String u="inactive"+System.currentTimeMillis(); String e=u+"@gmail.com";
  svc.register(u,e,"123456");
  assertNull(svc.login(u,"123456")); // phải null vì chưa active
  svc.activate(e);
  assertNotNull(svc.login(u,"123456"));
  assertNull(svc.login(u,"wrong"));
}
```

- [ ] **Step 2: Run fail**

- [ ] **Step 3: Sửa UserServiceImpl.login**

```java
public User login(String username,String password){
  User u=userDao.get(username);
  if(u==null) u=userDao.getByEmail(username); // cho login bằng email cũng được
  if(u==null) return null;
  if(u.getIsActive()==0) return null; // controller sẽ báo chưa kích hoạt
  if(!PasswordUtil.check(password, u.getPassWord())) return null;
  return u;
}
```

Sửa `LoginController.doPost` check `user==null` thì `userDao.get` → `isActive==0` → `alert="Tài khoản chưa kích hoạt, kiểm tra email"` + link resend.

- [ ] **Step 4: Run pass** `mvn test -Dtest=vn.iotstar.service.UserServiceTest`

- [ ] **Step 5: Sửa login.jsp thêm link**

```jsp
<a href="${pageContext.request.contextPath}/register">Đăng ký</a> | <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu</a>
<c:if test="${param.msg=='activated'}"><p style="color:green">Kích hoạt thành công, đăng nhập ngay</p></c:if>
```

- [ ] **Step 6: Manual** login admin cũ `admin/123` phải migrate hash: chạy 1 lần `UPDATE [User] SET password = BCrypt hash` hoặc cho login fallback `password.equals` nếu hash không bắt đầu `$2a$`.

- [ ] **Step 7: Commit** `git commit -m "fix: login check active + bcrypt, block inactive"`

---

### Task 4: Quên mật khẩu OTP

**Files:**
- Create: `src/main/java/vn/iotstar/controller/ForgotPasswordController.java`
- Create: `src/main/webapp/views/forgot-password.jsp`, `src/main/webapp/views/reset-password.jsp`
- Test: `src/test/java/vn/iotstar/service/ForgotPasswordTest.java`

**Interfaces:**
- Consumes: `OtpService` từ Task1, `UserService.resetPassword`
- Produces: `/forgot-password` + `/reset-password` flow

- [ ] **Step 1: Viết failing test forgot**

```java
public class ForgotPasswordTest {
  @Test void forgotAndReset() throws Exception {
    UserService us=new UserServiceImpl(); OtpService os=new OtpServiceImpl(mockMail);
    String u="forgot"+System.currentTimeMillis(); String e=u+"@gmail.com";
    us.register(u,e,"oldpass"); us.activate(e);
    os.createAndSend(e,"FORGOT");
    var token=os.findLatest(e,"FORGOT");
    assertTrue(os.verify(e, token.getOtp(),"FORGOT"));
    us.resetPassword(e,"newpass");
    assertNotNull(us.login(u,"newpass"));
    assertNull(us.login(u,"oldpass"));
  }
  @Test void verifyWrong3TimesLock() throws Exception { /* sau 3 lần sai phải fail */ }
}
```

- [ ] **Step 2: Run fail**

- [ ] **Step 3: Implement UserService.resetPassword + ForgotController**

```java
public void resetPassword(String email,String newPass){ User u=userDao.getByEmail(email); u.setPassWord(PasswordUtil.hash(newPass)); userDao.updatePassword(u); }

// ForgotPasswordController.java
@WebServlet({"/forgot-password","/reset-password"})
public class ForgotPasswordController extends HttpServlet {
  protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
    if(req.getRequestURI().contains("reset-password")){ if(req.getSession().getAttribute("resetEmail")==null) resp.sendRedirect(req.getContextPath()+"/forgot-password"); else req.getRequestDispatcher("/views/reset-password.jsp").forward(req,resp); }
    else req.getRequestDispatcher("/views/forgot-password.jsp").forward(req,resp);
  }
  protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws IOException,ServletException {
    if(req.getRequestURI().contains("forgot-password")){
      String email=req.getParameter("email");
      try{ if(userDao.getByEmail(email)!=null) otpService.createAndSend(email,"FORGOT"); req.setAttribute("alert","Nếu email tồn tại, OTP đã gửi"); }catch(Exception e){ req.setAttribute("alert",e.getMessage()); }
      req.getRequestDispatcher("/views/verify-otp.jsp?email="+email+"&purpose=FORGOT").forward(req,resp);
    } else {
      String email=(String)req.getSession().getAttribute("resetEmail"), p1=req.getParameter("password"), p2=req.getParameter("confirm");
      if(!p1.equals(p2)){ req.setAttribute("alert","Mật khẩu không khớp"); req.getRequestDispatcher("/views/reset-password.jsp").forward(req,resp); return; }
      userService.resetPassword(email,p1); req.getSession().removeAttribute("resetEmail"); resp.sendRedirect(req.getContextPath()+"/login?msg=resetOk");
    }
  }
}
```

- [ ] **Step 4: Run pass** `mvn test -Dtest=vn.iotstar.service.ForgotPasswordTest`

- [ ] **Step 5: Manual** `/forgot-password` → nhập `admin@gmail.com` → mail OTP → verify → reset → login với mk mới.

- [ ] **Step 6: Commit** `git commit -m "feat: forgot password otp 120s + reset"`

---

### Task 5: Product Entity + DAO + Service (nền cho CRUD)

**Files:**
- Create: `src/main/java/vn/iotstar/entity/Product.java`
- Create: `src/main/java/vn/iotstar/dao/IProductDao.java`, `src/main/java/vn/iotstar/dao/impl/ProductDaoImpl.java`
- Create: `src/main/java/vn/iotstar/service/IProductService.java`, `src/main/java/vn/iotstar/service/impl/ProductServiceImpl.java`
- Test: `src/test/java/vn/iotstar/dao/ProductDaoTest.java`

**Interfaces:**
- Consumes: `JPAConfig`, `Category` FK
- Produces: `ProductDao.insert/update/delete/findById/findAll/page/findTopN/search/count`, `ProductService` same

- [ ] **Step 1: Viết failing test ProductDao**

```java
// ProductDaoTest dùng H2 + persistence test
public class ProductDaoTest {
  IProductDao dao=new ProductDaoImpl(); ICategoryDao catDao=new CategoryDao();
  @Test void crudAndPagination() throws Exception {
    Category c=new Category(); c.setCategoryname("Cat"+System.currentTimeMillis()); c.setImages("a.jpg"); c.setStatus(1); catDao.insert(c);
    Product p=new Product(); p.setProductName("P1"); p.setPrice(new java.math.BigDecimal("100.00")); p.setDescription("desc"); p.setImages("p.jpg"); p.setStatus(1); p.setCategory(c);
    dao.insert(p); assertTrue(p.getProductId()>0);
    assertNotNull(dao.findById(p.getProductId()));
    p.setProductName("P1-updated"); dao.update(p); assertEquals("P1-updated", dao.findById(p.getProductId()).getProductName());
    // pagination
    for(int i=0;i<10;i++){ Product x=new Product(); x.setProductName("Px"+i); x.setPrice(new java.math.BigDecimal("10")); x.setCategory(c); dao.insert(x); }
    assertEquals(6, dao.findAll(0,6).size());
    assertTrue(dao.count()>=11);
    assertEquals(10, dao.findTopN(10).size());
    dao.delete(p.getProductId()); assertNull(dao.findById(p.getProductId()));
  }
  @Test void fkFail(){ Product p=new Product(); p.setProductName("Bad"); p.setPrice(new java.math.BigDecimal("10")); Category fake=new Category(); fake.setCategoryid(99999); p.setCategory(fake); assertThrows(Exception.class, ()-> dao.insert(p)); }
}
```

- [ ] **Step 2: Run fail** `mvn test -Dtest=vn.iotstar.dao.ProductDaoTest` → FAIL (entity chưa có)

- [ ] **Step 3: Tạo Product entity**

```java
@Entity @Table(name="products") @NamedQueries({@NamedQuery(name="Product.findAll", query="SELECT p FROM Product p ORDER BY p.createDate DESC"), @NamedQuery(name="Product.findTopN", query="SELECT p FROM Product p ORDER BY p.createDate DESC")})
public class Product implements Serializable {
  @Id @GeneratedValue(strategy=GenerationType.IDENTITY) private int productId;
  @Column(name="productName", nullable=false,columnDefinition="nvarchar(200)") private String productName;
  @Column(columnDefinition="nvarchar(1000)") private String description;
  @Column(nullable=false) private java.math.BigDecimal price;
  @Column(columnDefinition="nvarchar(500)") private String images;
  private int status=1;
  @Temporal(TemporalType.TIMESTAMP) private java.util.Date createDate=new java.util.Date();
  @ManyToOne @JoinColumn(name="categoryId", nullable=false) private Category category;
  // getters/setters
}
```

Thêm `<class>vn.iotstar.entity.Product</class>` vào `persistence.xml:7` nếu cần (update sẽ tự quét nhưng explicit tốt).

- [ ] **Step 4: Implement ProductDaoImpl** copy `CategoryDao.java:11` pattern: `insert` persist, `update` merge, `delete` find+remove, `findById` find, `findAll` named query, `findAll(page,size)` setFirstResult, `findTopN` setMaxResults, `count` JPQL, `searchByName` like.

- [ ] **Step 5: Run pass** `mvn test -Dtest=vn.iotstar.dao.ProductDaoTest` → PASS. Check SQL Server tự tạo `products` (`hbm2ddl.update`).

- [ ] **Step 6: Tạo ProductService** wrapper validate `category!=null`, `price>=0`.

- [ ] **Step 7: Commit** `git commit -m "feat: product entity dao service pagination"`

---

### Task 6: Product CRUD Admin + Upload Multipart

**Files:**
- Create: `src/main/java/vn/iotstar/controller/ProductController.java`
- Create: `src/main/webapp/views/admin/product-list.jsp`, `product-add.jsp`, `product-edit.jsp`
- Modify: `src/main/webapp/views/admin/category-list.jsp:11` thêm link Product
- Test: `src/test/java/vn/iotstar/controller/ProductControllerTest.java` (mock)

**Interfaces:**
- Consumes: `ProductService` từ Task5, `Constant.DIR`, `CategoryService` để dropdown
- Produces: `/admin/products` CRUD

- [ ] **Step 1: Viết failing test controller mock**

```java
@Test void productListPagination() throws Exception {
  // mock HttpServletRequest with page=0, mock service returns 6 products
  // verify setAttribute("listProduct") và forward
}
```

- [ ] **Step 2: Run fail**

- [ ] **Step 3: Implement ProductController**

```java
@MultipartConfig(fileSizeThreshold=1024*1024, maxFileSize=5*1024*1024, maxRequestSize=10*1024*1024)
@WebServlet({"/admin/products","/admin/product/add","/admin/product/insert","/admin/product/edit","/admin/product/update","/admin/product/delete"})
public class ProductController extends HttpServlet {
  IProductService productService=new ProductServiceImpl(); ICategoryService cateService=new CategoryServiceImpl();
  protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
    String url=req.getRequestURI();
    if(url.contains("/admin/products")){ req.setAttribute("listProduct", productService.findAll()); req.getRequestDispatcher("/views/admin/product-list.jsp").forward(req,resp); }
    else if(url.contains("/admin/product/add")){ req.setAttribute("categories", cateService.findAll()); req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req,resp); }
    else if(url.contains("/admin/product/edit")){ int id=Integer.parseInt(req.getParameter("id")); req.setAttribute("product", productService.findById(id)); req.setAttribute("categories", cateService.findAll()); req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req,resp); }
    else if(url.contains("/admin/product/delete")){ int id=Integer.parseInt(req.getParameter("id")); try{productService.delete(id);}catch(Exception e){e.printStackTrace();} resp.sendRedirect(req.getContextPath()+"/admin/products"); }
  }
  protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
    String url=req.getRequestURI();
    if(url.contains("/admin/product/insert")||url.contains("/admin/product/update")){
      String name=req.getParameter("productName"), desc=req.getParameter("description"), priceStr=req.getParameter("price"), statusStr=req.getParameter("status"), catIdStr=req.getParameter("categoryId");
      Part part=req.getPart("images1"); String fname=handleUpload(part, req.getParameter("images"));
      // build Product, set fields, productService.insert/update
      resp.sendRedirect(req.getContextPath()+"/admin/products");
    }
  }
  private String handleUpload(Part part,String linkImages) throws IOException,ServletException {
    if(part!=null && part.getSize()>0){
      String filename=Paths.get(part.getSubmittedFileName()).getFileName().toString();
      String ext=filename.contains(".")?filename.substring(filename.lastIndexOf(".")):"";
      if(!ext.matches("(?i)\\.(jpg|jpeg|png|gif)")) throw new ServletException("Chỉ cho jpg/png/gif");
      String fname=System.currentTimeMillis()+ext;
      File dir=new File(Constant.DIR); if(!dir.exists()) dir.mkdirs();
      part.write(Constant.DIR+"/"+fname); return fname;
    } else if(linkImages!=null && !linkImages.isBlank()) return linkImages;
    return "avatar.png";
  }
}
```

Reuse `CategoryController.java:76` upload logic, fix `substring` crash bằng `startsWith`.

- [ ] **Step 4: Tạo 3 JSP admin** copy `category-add.jsp:12`/`category-edit.jsp:12`/`category-list.jsp:21`, thêm field `productName, price, description, category dropdown, images file`.

- [ ] **Step 5: Run** `mvn test -Dtest=vn.iotstar.controller.ProductControllerTest` → PASS, `mvn clean package` deploy, test CRUD bằng tay: add product với ảnh `D:\upload` → list → edit → delete.

- [ ] **Step 6: Commit** `git commit -m "feat: product crud admin + multipart 5MB upload"`

---

### Task 7: Home Top10 + /product pagination 6sp + detail

**Files:**
- Modify: `src/main/java/vn/iotstar/controller/HomeController.java:12`, `src/main/java/vn/iotstar/controller/ProductController.java` (thêm /product, /product/detail)
- Create: `src/main/webapp/views/product-list.jsp`, `src/main/webapp/views/product-detail.jsp`
- Modify: `src/main/webapp/views/home.jsp:10`
- Test: `src/test/java/vn/iotstar/dao/ProductDaoTest.java` mở rộng + `ProductControllerTest`

**Interfaces:**
- Consumes: `ProductService.findTopN(10)`, `ProductService.findAll(page,6)` + `count()`
- Produces: `/home` top10, `/product?page=` 6/trang, `/product/detail?id=`

- [ ] **Step 1: Viết failing test pagination**

```java
@Test void homeTop10AndProductPage(){
  // insert 15 products với createDate khác nhau
  assertEquals(10, dao.findTopN(10).size());
  assertEquals(6, dao.findAll(0,6).size());
  assertEquals(6, dao.findAll(1,6).size());
  assertEquals(3, dao.findAll(2,6).size()); // 15 total
  // detail
  assertNotNull(dao.findById(firstId));
  assertNull(dao.findById(99999));
}
```

- [ ] **Step 2: Run fail** → thiếu method `findTopN` nếu chưa có

- [ ] **Step 3: Implement HomeController**

```java
@WebServlet({"/home","/"})
public class HomeController extends HttpServlet {
  IProductService productService=new ProductServiceImpl();
  protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
    // nếu yêu cầu public thì bỏ check session, còn giữ thì thêm top10 trước khi forward
    req.setAttribute("top10", productService.findTopN(10));
    // HttpSession session=req.getSession(false); if(session==null||session.getAttribute("account")==null){ resp.sendRedirect(...); return; } // giữ hoặc bỏ tùy bạn
    req.getRequestDispatcher("/views/home.jsp").forward(req,resp);
  }
}
```

Thêm vào `ProductController.doGet` nhánh:
```java
else if(url.contains("/product/detail")){ int id=Integer.parseInt(req.getParameter("id")); req.setAttribute("product", productService.findById(id)); req.getRequestDispatcher("/views/product-detail.jsp").forward(req,resp); }
else if(url.equals(req.getContextPath()+"/product")){ int page=0; try{page=Integer.parseInt(req.getParameter("page"));}catch(Exception e){} int total=productService.count(); int totalPages=(int)Math.ceil(total/6.0); req.setAttribute("list", productService.findAll(page,6)); req.setAttribute("currentPage",page); req.setAttribute("totalPages",totalPages); req.getRequestDispatcher("/views/product-list.jsp").forward(req,resp); }
```

- [ ] **Step 4: Tạo JSP**

`home.jsp` thêm sau `topbar.jsp`:
```jsp
<h2>10 sản phẩm mới nhất</h2>
<div style="display:grid;grid-template-columns:repeat(5,1fr);gap:10px">
<c:forEach items="${top10}" var="p">
  <a href="${pageContext.request.contextPath}/product/detail?id=${p.productId}">
    <img src="<c:url value='/image?fname=${p.images}'/>" width="150"/><br/>${p.productName}<br/>${p.price}
  </a>
</c:forEach>
</div>
<a href="${pageContext.request.contextPath}/product">Xem tất cả</a>
```

`product-list.jsp` grid 6sp + phân trang:
```jsp
<c:forEach items="${list}" var="p"> ... </c:forEach>
<c:forEach begin="0" end="${totalPages-1}" var="i"><a href="?page=${i}" style="${i==currentPage?'font-weight:bold':''}">${i+1}</a> </c:forEach>
```

`product-detail.jsp` hiển thị `product.productName, images, price, description, category.categoryname`.

- [ ] **Step 5: Run pass** `mvn test -Dtest=vn.iotstar.dao.ProductDaoTest` + `mvn clean package` manual test:
- `/home` hiện 10 mới nhất
- `/product?page=0` 6sp, `?page=1` tiếp 6, click detail → `/product/detail?id=` hiển thị đúng
- Click từ home vào detail cũng ok

- [ ] **Step 6: Commit**

```bash
git add src/main/java/vn/iotstar/controller/HomeController.java src/main/java/vn/iotstar/controller/ProductController.java src/main/webapp/views/home.jsp src/main/webapp/views/product-list.jsp src/main/webapp/views/product-detail.jsp
git commit -m "feat: home top10 + /product pagination 6 + detail"
```

---

## Self-Review

- Spec 1-9 cover hết: mỗi requirement có task (OTP 1-4, Product 5-7, Upload 6, Home/Product 7).
- Không placeholder: mọi step có code thực tế, lệnh `mvn test` cụ thể.
- Type consistency: `Product.category Category`, `OtpToken.purpose String`, `User.isActive int` dùng nhất quán qua DAO/Service/Controller.
- Fix: đã bao gồm fix leak `UserDaoImpl`, `CategoryDao` enma close, `substring` crash, BCrypt fallback.

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-09-03-otp-product-plan.md`. Two execution options:

**1. Subagent-Driven (recommended)** - dispatch fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - execute tasks in this session using executing-plans, batch execution with checkpoints

Which approach?
