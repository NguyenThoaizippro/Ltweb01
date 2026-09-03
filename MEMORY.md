# MEMORY — bt01 Shopping Servlet MVC

> File ghi nhớ cấu trúc dự án để lần sau chỉnh sửa nhanh. Đọc file này trước khi code.

## 1. Tổng quan
- **Tên:** bt01 — Shopping Servlet Service MVC
- **Kiểu:** Maven WAR, Servlet Jakarta EE 6, JSP + JSTL, deploy trên Tomcat
- **JDK:** 17, packaging `war` (`pom.xml:8`)
- **Build:** `mvn clean package` → `target/bt01-1.0.war`
- **Entry:** `src/main/webapp/index.jsp:3` redirect `/login`
- **Git:** 1 commit `74d02c3 first commit`

## 2. Tech stack (`pom.xml:10-95`)
| Thành phần | Version | Ghi chú |
|---|---|---|
| jakarta.servlet-api | 6.0.0 | provided |
| jakarta.servlet.jsp-api | 3.1.0 | provided |
| jstl-api 3.0.0 + impl 3.0.1 | runtime | |
| Hibernate ORM | 7.4.6.Final | JPA |
| hibernate-validator 8.0.5 + validation-api 3.1.1 + expressly 5.0.0 | validation |
| mssql-jdbc 9.4.0.jre8 + mysql-connector 8.0.13 | driver (nhưng persistence chỉ dùng SQL Server) |
| commons-io 2.11.0 | `IOUtils` trong DownloadImageController |
| lombok 1.18.32 | provided, dùng `@Data` nhưng entity vẫn viết getter/setter thủ công |

## 3. Cây thư mục
```
bt01/
├── pom.xml
├── .classpath / .project / .settings/ / .vscode/  # Eclipse + VSCode config
├── src/main/java/vn/iotstar/
│   ├── config/
│   │   ├── JPAConfig.java          # EntityManagerFactory singleton "jpa-hibernate-mysql"
│   │   ├── JpaListener.java        # @WebListener auto create table khi Tomcat start
│   │   └── Test.java               # main() test persist Category+Video
│   ├── connection/
│   │   └── DBConnection.java       # JDBC raw cho User (sqlserver://localhost\SQLEXPRESS/bt01)
│   ├── entity/
│   │   ├── Category.java           # @Entity categories, @OneToMany videos
│   │   └── Video.java              # @Entity Videos, @ManyToOne category
│   ├── model/
│   │   └── User.java               # POJO thuần (không phải @Entity), map table [User] via JDBC
│   ├── dao/
│   │   ├── ICategoryDao.java / CategoryDao.java       # JPA
│   │   └── UserDao.java / impl/UserDaoImpl.java       # JDBC
│   ├── service/
│   │   ├── ICategoryService.java / impl/CategoryServiceImpl.java
│   │   └── UserService.java / impl/UserServiceImpl.java
│   ├── controller/
│   │   ├── LoginController.java      # /login
│   │   ├── LogoutController.java     # /logout
│   │   ├── WaitingController.java    # /waiting (phân quyền theo roleid)
│   │   ├── HomeController.java       # /home
│   │   ├── ManagerHomeController.java# /manager/home
│   │   ├── CategoryController.java   # /admin/** (CRUD category)
│   │   └── DownloadImageController.java # /image?fname=
│   └── util/
│       └── Constant.java           # DIR=D:\upload, SESSION_USERNAME, COOKIE_REMEMBER
├── src/main/resources/META-INF/persistence.xml  # persistence-unit jpa-hibernate-mysql
├── src/main/webapp/
│   ├── WEB-INF/web.xml             # welcome-file index.jsp, tracking COOKIE
│   ├── WEB-INF/lib/                # jar copy (commons-io, jstl, mssql)
│   ├── index.jsp
│   └── views/
│       ├── login.jsp / home.jsp / topbar.jsp
│       ├── admin/category-list.jsp / category-add.jsp / category-edit.jsp
│       └── manager/home.jsp
├── src/test/java/vn/iotstar/test/  # rỗng
└── target/                         # build output (ignore)
```

## 4. Config quan trọng

### 4.1 persistence.xml (`src/main/resources/META-INF/persistence.xml:6-22`)
- `persistence-unit name="jpa-hibernate-mysql"`
- `class` Category, Video
- JDBC: `jdbc:sqlserver://localhost\SQLEXPRESS;databaseName=bt01;trustServerCertificate=true`, `sa/1234`
- `hibernate.hbm2ddl.auto=update`, `dialect=SQLServerDialect`, `show_sql=true`

### 4.2 JPAConfig (`config/JPAConfig.java:10`)
```java
Persistence.createEntityManagerFactory("jpa-hibernate-mysql")
getEntityManager() // mỗi lần tạo EntityManager mới, nhớ close
```
### 4.3 JpaListener (`config/JpaListener.java:8`) — `@WebListener`
- `contextInitialized` gọi `JPAConfig.getEntityManager().close()` để Hibernate auto-create/update tables.

### 4.4 Constant (`util/Constant.java:4`)
```java
DIR = "D:\\upload"           // nơi lưu ảnh upload
SESSION_USERNAME = "username"
COOKIE_REMEMBER = "username" // cookie rememberMe 30*60s
```

### 4.5 DBConnection (`connection/DBConnection.java:8`) — chỉ dùng cho UserDao

## 5. Entity / Model

### Category (`entity/Category.java:12`)
- `@Table(name="categories")`, `@NamedQuery Category.findAll`
- `int categoryid @GeneratedValue IDENTITY`, `String categoryname nvarchar(50) @NotEmpty`, `String images nvarchar(500)`, `int status`, `List<Video> videos @OneToMany(mappedBy="category")`
- Có `@Data` + `@NoArgsConstructor/@AllArgsConstructor` nhưng vẫn viết thủ công getter/setter (dư code).

### Video (`entity/Video.java:12`)
- `@Table(name="Videos")`, `@Id String videoId`, `int active, description, poster, title, views`, `@ManyToOne Category category @JoinColumn(CategoryId)`

### User (`model/User.java:7`) — KHÔNG phải JPA Entity
- Field: `id, email, userName, fullName, passWord, avatar, roleid, phone, createdDate`
- Map tay trong `UserDaoImpl.java:30-41` từ `SELECT * FROM [User] WHERE username=?`
- `roleid`: 1=admin, 2=manager, khác=user

## 6. DAO / Service

### ICategoryDao (`dao/ICategoryDao.java:7`) — 8 method
`insert, update, delete, findById, findByCategoryname, findAll, findAll(page,pagesize), searchByName, count`
- Impl `CategoryDao.java:11` dùng `JPAConfig.getEntityManager()` + `EntityTransaction` cho write, `TypedQuery` cho read. Lưu ý `findByCategoryname:82` dùng `getSingleResult()` sẽ ném `NoResultException` nếu không tìm thấy (đang catch như Exception).

### UserDao (`dao/UserDao.java:5`) — `User get(String username)`
- Impl `UserDaoImpl.java:11 extends DBConnection`, JDBC raw, không đóng `conn/ps/rs` (leak).

### ICategoryService (`service/ICategoryService.java:6`) — mirror DAO
- Impl `CategoryServiceImpl.java:10` — `cateDao = new CategoryDao()`, `insert` check `findByCategoryname==null` mới insert, `update` check `findById!=null`, `delete` try-catch swallowing, `findByCategoryname` trả về null nếu exception.

### UserService (`service/UserService.java:5`) — `login(username,password), get(username)`
- Impl `UserServiceImpl.java:12` — `login` so sánh `password.equals(user.getPassWord())` plain text.

## 7. Controller & Routing

| URL | Controller:line | Method | Chức năng |
|---|---|---|---|
| `/` | `index.jsp:3` | redirect | → `/login` |
| `/login` | `LoginController.java:17` | GET/POST | GET: check session account hoặc cookie → `/waiting`, else forward `login.jsp`. POST: validate rỗng, `UserService.login`, set `session.account`, cookie remember 30min, redirect `/waiting` |
| `/logout` | `LogoutController.java:14` | GET | invalidate session, xóa cookie, → `/login` |
| `/waiting` | `WaitingController.java:17` | GET | Role router: `roleid 1→/admin/categories`, `2→/manager/home`, else→`/home`. Cũng xử lý `SESSION_USERNAME` từ cookie |
| `/home` | `HomeController.java:12` | GET | check `session.account`, forward `views/home.jsp` |
| `/manager/home` | `ManagerHomeController.java:12` | GET | check session, forward `views/manager/home.jsp` |
| `/admin/categories` | `CategoryController.java:24` | GET | `findAll` → `category-list.jsp` |
| `/admin/category/add` | `CategoryController.java:37` | GET | forward `category-add.jsp` |
| `/admin/category/insert` | `CategoryController.java:60` | POST | `@MultipartConfig`, lấy `categoryname/status/images` + `Part images1` upload `D:\upload/fname`, `insert` |
| `/admin/category/edit?id=` | `CategoryController.java:39` | GET | `findById` → `category-edit.jsp` |
| `/admin/category/update` | `CategoryController.java:103` | POST | update + xóa file cũ nếu không phải https |
| `/admin/category/delete?id=` | `CategoryController.java:44` | GET | `delete(id)` → redirect `/admin/categories` |
| `/image?fname=` | `DownloadImageController.java:15` | GET | đọc `D:\upload/fname`, set contentType, `IOUtils.copy` |

## 8. View (JSP)

- `views/login.jsp:17` form POST `/login` với `username, password, remember`
- `views/topbar.jsp:5` include chung: hiện `Đăng nhập` hoặc `Xin chào fullName/userName | Đăng xuất`
- `views/home.jsp:10` include topbar + "Bạn đã đăng nhập thành công"
- `views/admin/category-list.jsp:21` table `listcate` với ảnh (https → direct, else `/image?fname=`), status 1=Hoạt động else Khóa, link Sửa/Xóa
- `views/admin/category-add.jsp:12` form multipart `categoryname, images(text), images1(file), status radio`
- `views/admin/category-edit.jsp:12` tương tự add, có hidden `categoryid`, preview ảnh
- `views/manager/home.jsp:11` trang manager đơn giản

## 9. Luồng chính
```
index.jsp → /login (GET) → login.jsp → POST /login → session.account → /waiting
/waiting check roleid → 1:admin/categories, 2:manager/home, else:/home
/admin/categories → list → add/edit/delete → upload D:\upload → /image?fname= preview
```

## 10. Build & Run
```bash
mvn clean package                 # ra target/bt01-1.0.war
# Deploy war vào Tomcat 10+ (Jakarta EE 6), JDK 17
# SQL Server: tạo DB bt01, user sa/1234, JpaListener sẽ auto tạo bảng categories/videos
# Tạo bảng [User] thủ công (không do JPA tạo):
# CREATE TABLE [User](id int identity, username nvarchar(50), password nvarchar(50), ...)
# Ảnh upload: tạo thư mục D:\upload và cấp quyền ghi
```

## 11. Ghi chú chỉnh sửa nhanh (where to touch)
- **Thêm entity mới:** tạo `entity/New.java` → khai báo `@Entity`, thêm `<class>` vào `persistence.xml:7` → `JpaListener` tự tạo bảng.
- **Thêm DAO:** copy pattern `CategoryDao.java:14` (insert/update/delete/find) → interface `ICategoryDao`.
- **Thêm Service:** wrapper DAO + check logic (vd `CategoryServiceImpl.java:32` check trùng tên).
- **Thêm Controller:** `@WebServlet(urlPatterns="...")`, `doGet/doPost` forward JSP hoặc redirect, lấy `cateService`/`userService`.
- **Thêm JSP:** đặt trong `views/<role>/`, dùng `jakarta.tags.core` (`<%@ taglib prefix="c" uri="jakarta.tags.core" %>`), include `topbar.jsp`.
- **Đổi DB/đường dẫn upload:** `persistence.xml:10-14` + `DBConnection.java:8` + `Constant.java:4` (3 chỗ đồng bộ).
- **Validation:** đã có `hibernate-validator` + `jakarta.validation-api`, dùng `@NotEmpty` như `Category.java:28`.

## 12. Vấn đề / Nợ kỹ thuật (ponytail notes)
- `User` vs `Category/Video`: 2 cơ chế khác nhau (JDBC vs JPA) → nên thống nhất JPA cho User.
- `UserDaoImpl.java:13` field `conn/ps/rs` public, không đóng → leak connection.
- `CategoryDao.findAll()/searchByName/count` không `enma.close()` → leak EntityManager.
- `CategoryDao.findByCategoryname` ném Exception để báo "đã tồn tại" nhưng Service lại coi null là chưa tồn tại → logic ngược, dễ nhầm.
- `Category.java` dùng Lombok `@Data` nhưng vẫn viết tay getter/setter → dư, có thể xóa.
- `Constant.DIR` cứng `D:\upload` → nên đổi thành relative hoặc config.
- `CategoryController:125` check `substring(0,5).equals("https")` sẽ crash nếu `images` <5 ký tự đã check trước đó nhưng vẫn rủi ro.
- `src/test/java` rỗng, chưa có test.
- `WEB-INF/lib` chứa jar copy trong khi đã có Maven deps → dư, có thể xóa lib folder.

## 13. File cấu hình IDE
- `.classpath:3` source `src/main/java`, `src/main/resources`, `src/test/java`, `target/generated-sources/annotations`
- `.project:29` natures: `JavaEMFNature, ModuleCoreNature, javanature, maven2Nature, jsNature`
- `.settings/org.eclipse.wst.common.project.facet.core.xml` + `org.eclipse.jdt.core.prefs` (Java 17)
- `.vscode/settings.json:2` `java.configuration.updateBuildConfiguration: interactive`
- `.gitignore:1` ignore `/target/, .vscode/`
