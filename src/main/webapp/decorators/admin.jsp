<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> | toi di ban hang Admin</title>

    <!-- Google Fonts: Plus Jakarta Sans -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --admin-bg: #0f172a;
            --admin-card: #1e293b;
            --primary: #38bdf8;
            --primary-hover: #0284c7;
            --page-bg: #f8fafc;
            --sidebar-width: 260px;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, Roboto, sans-serif;
            background: var(--page-bg);
            color: #1e293b;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            -webkit-font-smoothing: antialiased;
        }

        /* Top Admin Navbar */
        .admin-header {
            background: var(--admin-bg);
            color: #ffffff;
            padding: 14px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .admin-brand {
            font-size: 19px;
            font-weight: 800;
            color: #ffffff;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: -0.5px;
        }
        .admin-brand-badge {
            background: linear-gradient(135deg, #0284c7 0%, #38bdf8 100%);
            color: #ffffff;
            font-size: 11px;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 6px;
            text-transform: uppercase;
        }
        .admin-nav-links {
            display: flex;
            align-items: center;
            gap: 16px;
            list-style: none;
        }
        .admin-nav-links a {
            color: #94a3b8;
            text-decoration: none;
            font-size: 13.5px;
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 8px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .admin-nav-links a:hover {
            color: #ffffff;
            background: rgba(255,255,255,0.06);
        }
        .admin-nav-links a.btn-logout {
            color: #f87171;
            background: rgba(239, 68, 68, 0.1);
        }
        .admin-nav-links a.btn-logout:hover {
            background: rgba(239, 68, 68, 0.2);
            color: #fca5a5;
        }

        /* Layout */
        .admin-layout {
            display: flex;
            flex: 1;
        }

        /* Modern Sidebar */
        .admin-sidebar {
            width: var(--sidebar-width);
            background: #ffffff;
            border-right: 1px solid #e2e8f0;
            padding: 28px 16px;
            display: flex;
            flex-direction: column;
            gap: 6px;
            flex-shrink: 0;
        }
        .sidebar-title {
            font-size: 11px;
            font-weight: 800;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 8px;
            padding: 0 12px;
        }
        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 11px 14px;
            border-radius: 10px;
            text-decoration: none;
            color: #475569;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
        }
        .sidebar-link i {
            font-size: 17px;
            color: #64748b;
            transition: color 0.2s;
        }
        .sidebar-link:hover {
            background: #eff6ff;
            color: #2563eb;
        }
        .sidebar-link:hover i {
            color: #2563eb;
        }
        .sidebar-link.active {
            background: #2563eb;
            color: #ffffff;
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.25);
        }
        .sidebar-link.active i {
            color: #ffffff;
        }

        /* Main Content Container */
        .admin-content {
            flex: 1;
            padding: 32px 40px;
            max-width: calc(100vw - var(--sidebar-width));
            overflow-x: auto;
        }

        /* Footer */
        .admin-footer {
            background: #ffffff;
            border-top: 1px solid #e2e8f0;
            padding: 16px;
            text-align: center;
            font-size: 12.5px;
            color: #64748b;
        }
    </style>
    <sitemesh:write property='head'/>
</head>
<body>

    <!-- Header -->
    <header class="admin-header">
        <a href="${pageContext.request.contextPath}/admin/categories" class="admin-brand">
            <span>toi di ban hang</span>
            <span class="admin-brand-badge">ADMIN</span>
        </a>
        <ul class="admin-nav-links">
            <li>
                <a href="${pageContext.request.contextPath}/home" target="_blank">
                    <i class="bi bi-box-arrow-up-right"></i> Xem Trang Bán Hàng
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/profile">
                    <i class="bi bi-person-circle"></i> Hồ Sơ Cá Nhân
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                    <i class="bi bi-power"></i> Đăng Xuất
                </a>
            </li>
        </ul>
    </header>

    <!-- Layout: Sidebar + Main Content -->
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <div class="sidebar-title">Quản Lý Sản Phẩm</div>
            <a href="${pageContext.request.contextPath}/admin/products" class="sidebar-link">
                <i class="bi bi-phone"></i> Tất Cả Sản Phẩm (50)
            </a>
            <a href="${pageContext.request.contextPath}/admin/product/add" class="sidebar-link">
                <i class="bi bi-plus-circle"></i> Thêm Sản Phẩm Mới
            </a>

            <div class="sidebar-title" style="margin-top: 24px;">Quản Lý Danh Mục</div>
            <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link">
                <i class="bi bi-folder2-open"></i> Danh Sách Danh Mục
            </a>
            <a href="${pageContext.request.contextPath}/admin/category/add" class="sidebar-link">
                <i class="bi bi-folder-plus"></i> Thêm Danh Mục Mới
            </a>

            <div class="sidebar-title" style="margin-top: 24px;">Tài Khoản & Cài Đặt</div>
            <a href="${pageContext.request.contextPath}/profile" class="sidebar-link">
                <i class="bi bi-person-gear"></i> Thông Tin Quản Trị
            </a>
            <a href="${pageContext.request.contextPath}/home" class="sidebar-link">
                <i class="bi bi-arrow-left-circle"></i> Quay Lại Trang Chủ
            </a>
        </aside>

        <main class="admin-content">
            <sitemesh:write property='body'/>
        </main>
    </div>

    <!-- Footer -->
    <footer class="admin-footer">
        <p>&copy; 2026 toi di ban hang Management Panel · Xây dựng trên nền tảng Jakarta Servlet 6.0 & SiteMesh 3.</p>
    </footer>

</body>
</html>
