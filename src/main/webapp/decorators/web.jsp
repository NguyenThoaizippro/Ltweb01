<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> | toi di ban hang</title>
    
    <!-- Google Fonts: Plus Jakarta Sans (Chuẩn font công nghệ cao cấp) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --primary-light: #eff6ff;
            --secondary: #0f172a;
            --accent: #f59e0b;
            --danger: #ef4444;
            --success: #10b981;
            --bg-page: #f8fafc;
            --bg-card: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --radius-lg: 16px;
            --radius-md: 12px;
            --radius-pill: 9999px;
            --shadow-subtle: 0 4px 20px -2px rgba(15, 23, 42, 0.05);
            --shadow-hover: 0 20px 35px -4px rgba(15, 23, 42, 0.12);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, Roboto, sans-serif;
            background-color: var(--bg-page);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            -webkit-font-smoothing: antialiased;
        }

        /* Top Notification Bar */
        .top-banner {
            background: linear-gradient(90deg, #0f172a 0%, #1e293b 100%);
            color: #94a3b8;
            font-size: 12.5px;
            padding: 8px 20px;
            text-align: center;
            font-weight: 500;
            border-bottom: 1px solid rgba(255,255,255,0.06);
        }
        .top-banner strong { color: #f8fafc; }
        .top-banner span.badge {
            background: #2563eb;
            color: #fff;
            padding: 2px 8px;
            border-radius: var(--radius-pill);
            font-size: 11px;
            font-weight: 700;
            margin-right: 6px;
        }

        /* Glassmorphism Sticky Header */
        .site-header {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.8);
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.03);
            transition: all 0.25s ease;
        }
        .header-inner {
            max-width: 1280px;
            margin: 0 auto;
            padding: 12px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        /* Brand Logo (Text-only theo yeu cau: toi di ban hang) */
        .brand {
            font-size: 22px;
            font-weight: 800;
            color: var(--text-main);
            text-decoration: none;
            letter-spacing: -0.5px;
            transition: color 0.2s ease;
        }
        .brand:hover {
            color: var(--primary);
        }
        .brand-icon {
            width: 38px;
            height: 38px;
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            color: #ffffff;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 19px;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }
        .brand span.tag {
            font-size: 10px;
            font-weight: 700;
            background: #f1f5f9;
            color: #2563eb;
            padding: 2px 6px;
            border-radius: 6px;
            border: 1px solid #dbeafe;
            margin-left: 4px;
        }

        /* Pill Search Bar */
        .header-search {
            flex: 1;
            max-width: 480px;
            position: relative;
        }
        .header-search form {
            display: flex;
            align-items: center;
            position: relative;
        }
        .header-search input {
            width: 100%;
            padding: 10px 44px 10px 18px;
            background: #f1f5f9;
            border: 1.5px solid transparent;
            border-radius: var(--radius-pill);
            font-size: 14px;
            font-family: inherit;
            color: var(--text-main);
            transition: all 0.2s ease;
        }
        .header-search input:focus {
            outline: none;
            background: #ffffff;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.12);
        }
        .header-search button {
            position: absolute;
            right: 12px;
            background: none;
            border: none;
            color: var(--text-muted);
            font-size: 16px;
            cursor: pointer;
            transition: color 0.2s;
        }
        .header-search button:hover { color: var(--primary); }

        /* Navigation Links */
        .nav-links {
            display: flex;
            align-items: center;
            gap: 8px;
            list-style: none;
        }
        .nav-links a {
            text-decoration: none;
            color: #475569;
            font-weight: 600;
            font-size: 14px;
            padding: 8px 14px;
            border-radius: 8px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .nav-links a:hover {
            color: var(--primary);
            background: var(--primary-light);
        }
        .nav-links a.admin-btn {
            background: #fef3c7;
            color: #b45309;
            font-weight: 700;
            border: 1px solid #fde68a;
        }
        .nav-links a.admin-btn:hover {
            background: #fde68a;
            color: #92400e;
        }

        /* User Navigation & Avatar */
        .user-nav {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .user-greeting {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            padding: 4px 10px 4px 4px;
            border-radius: var(--radius-pill);
            background: #ffffff;
            border: 1px solid var(--border-color);
            transition: all 0.2s;
        }
        .user-greeting:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .user-avatar-sm {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #3b82f6;
        }
        .btn-logout {
            font-size: 13px;
            font-weight: 600;
            color: var(--danger);
            text-decoration: none;
            padding: 6px 14px;
            border: 1px solid #fee2e2;
            background: #fef2f2;
            border-radius: var(--radius-pill);
            transition: all 0.2s;
        }
        .btn-logout:hover {
            background: #fee2e2;
            color: #b91c1c;
        }
        .btn-login {
            font-size: 14px;
            color: #ffffff;
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            text-decoration: none;
            padding: 8px 18px;
            border-radius: var(--radius-pill);
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
            transition: all 0.2s;
        }
        .btn-login:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(37, 99, 235, 0.35);
        }

        /* Site Body */
        .site-body {
            flex: 1;
            width: 100%;
        }

        /* Modern VIP Footer */
        .site-footer {
            background: #ffffff;
            border-top: 1px solid var(--border-color);
            margin-top: 60px;
            padding-top: 48px;
            padding-bottom: 32px;
        }
        .footer-inner {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 24px;
        }
        .features-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
            padding-bottom: 40px;
            border-bottom: 1px solid #f1f5f9;
            margin-bottom: 36px;
        }
        @media (max-width: 900px) {
            .features-grid { grid-template-columns: repeat(2, 1fr); }
            .header-search { display: none; }
        }
        @media (max-width: 600px) {
            .features-grid { grid-template-columns: 1fr; }
        }
        .feature-item {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .feature-icon {
            width: 46px;
            height: 46px;
            border-radius: 12px;
            background: var(--primary-light);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
        }
        .feature-item h4 {
            font-size: 14.5px;
            font-weight: 700;
            margin-bottom: 3px;
            color: var(--text-main);
        }
        .feature-item p {
            font-size: 12.5px;
            color: var(--text-muted);
            margin: 0;
            line-height: 1.4;
        }
        .footer-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
            color: var(--text-muted);
            flex-wrap: wrap;
            gap: 16px;
        }
        .footer-links {
            display: flex;
            gap: 20px;
        }
        .footer-links a {
            color: var(--text-muted);
            text-decoration: none;
            transition: color 0.2s;
        }
        .footer-links a:hover { color: var(--primary); }
    </style>
    <sitemesh:write property='head'/>
</head>
<body>

    <!-- Top Announcement Bar -->
    <div class="top-banner">
        <span class="badge">HOT</span>
        <strong>Siêu Hội Công Nghệ 2026:</strong> Giảm tới 40% cho iPhone 16 & Galaxy AI. Bảo hành chính hãng 12T, miễn phí vận chuyển toàn quốc!
    </div>

    <!-- Glassmorphism Header -->
    <header class="site-header">
        <div class="header-inner">
            <!-- Brand: Text-only toi di ban hang -->
            <a href="${pageContext.request.contextPath}/home" class="brand">
                toi di ban hang
            </a>

            <!-- Search bar dạng viên thuốc -->
            <div class="header-search">
                <form action="${pageContext.request.contextPath}/product" method="get">
                    <input type="text" name="keyword" placeholder="Tìm kiếm iPhone, Samsung, Xiaomi..." value="${keyword}">
                    <button type="submit" title="Tìm kiếm"><i class="bi bi-search"></i></button>
                </form>
            </div>

            <!-- Navigation Links -->
            <ul class="nav-links">
                <li>
                    <a href="${pageContext.request.contextPath}/home">
                        <i class="bi bi-house-door"></i> Trang chủ
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/product">
                        <i class="bi bi-grid"></i> Sản phẩm
                    </a>
                </li>
                <c:if test="${sessionScope.account != null && sessionScope.account.roleid == 1}">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/categories" class="admin-btn">
                            <i class="bi bi-shield-lock-fill"></i> Quản trị
                        </a>
                    </li>
                </c:if>
            </ul>

            <!-- User Auth Navigation -->
            <div class="user-nav">
                <c:choose>
                    <c:when test="${sessionScope.account != null}">
                        <a href="${pageContext.request.contextPath}/profile" class="user-greeting" title="Hồ sơ tài khoản">
                            <c:choose>
                                <c:when test="${sessionScope.account.avatar != null && fn:startsWith(sessionScope.account.avatar, 'http')}">
                                    <img src="${sessionScope.account.avatar}" class="user-avatar-sm" alt="Avatar">
                                </c:when>
                                <c:when test="${sessionScope.account.avatar != null && not empty sessionScope.account.avatar}">
                                    <img src="<c:url value='/image?fname=${sessionScope.account.avatar}'/>" class="user-avatar-sm" alt="Avatar">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://ui-avatars.com/api/?name=${sessionScope.account.userName}&background=2563eb&color=fff&bold=true" class="user-avatar-sm" alt="Avatar">
                                </c:otherwise>
                            </c:choose>
                            <span>${not empty sessionScope.account.fullName ? sessionScope.account.fullName : sessionScope.account.userName}</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="btn-logout" title="Đăng xuất">
                            <i class="bi bi-box-arrow-right"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn-login">
                            <i class="bi bi-person-fill me-1"></i> Đăng nhập
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <!-- Main Content Area -->
    <main class="site-body">
        <sitemesh:write property='body'/>
    </main>

    <!-- VIP Footer -->
    <footer class="site-footer">
        <div class="footer-inner">
            <!-- 4 Cam kết dịch vụ VIP -->
            <div class="features-grid">
                <div class="feature-item">
                    <div class="feature-icon"><i class="bi bi-shield-check"></i></div>
                    <div>
                        <h4>100% Chính Hãng</h4>
                        <p>Cam kết sản phẩm phân phối chính hãng VN/A, nguyên seal</p>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon"><i class="bi bi-lightning-charge"></i></div>
                    <div>
                        <h4>Giao Hàng Siêu Tốc</h4>
                        <p>Nhận hàng trong 2h tại khu vực nội thành, miễn phí ship</p>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon"><i class="bi bi-arrow-repeat"></i></div>
                    <div>
                        <h4>Đổi Trả 30 Ngày</h4>
                        <p>Lỗi 1 đổi 1 nhanh chóng trong 30 ngày nếu có lỗi phần cứng</p>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon"><i class="bi bi-credit-card"></i></div>
                    <div>
                        <h4>Trả Góp 0% Lãi Suất</h4>
                        <p>Hỗ trợ thẻ tín dụng và CCCD duyệt hồ sơ chỉ trong 5 phút</p>
                    </div>
                </div>
            </div>

            <!-- Footer Links & Copyright -->
            <div class="footer-bottom">
                <div>
                    <strong>toi di ban hang</strong> &copy; 2026. Nền tảng thương mại điện tử Jakarta Servlet 6.0 & JPA Hibernate.
                </div>
                <div class="footer-links">
                    <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/product">Sản phẩm</a>
                    <a href="${pageContext.request.contextPath}/profile">Hồ sơ cá nhân</a>
                </div>
            </div>
        </div>
    </footer>

</body>
</html>
