<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> | BT01 Admin</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, Roboto, sans-serif; background: #f1f5f9; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; }
        
        .admin-header { background: #0f172a; color: #fff; padding: 12px 24px; display: flex; justify-content: space-between; align-items: center; }
        .admin-brand { font-size: 18px; font-weight: 700; color: #38bdf8; text-decoration: none; }
        .admin-nav-links { display: flex; align-items: center; gap: 16px; list-style: none; }
        .admin-nav-links a { color: #cbd5e1; text-decoration: none; font-size: 14px; }
        .admin-nav-links a:hover { color: #fff; }
        
        .admin-layout { display: flex; flex: 1; }
        .admin-sidebar { width: 240px; background: #ffffff; border-right: 1px solid #e2e8f0; padding: 24px 16px; display: flex; flex-direction: column; gap: 8px; }
        .sidebar-title { font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; margin-bottom: 8px; padding-left: 12px; }
        .sidebar-link { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 6px; text-decoration: none; color: #475569; font-size: 14px; font-weight: 500; transition: all 0.2s; }
        .sidebar-link:hover { background: #f1f5f9; color: #0284c7; }
        
        .admin-content { flex: 1; padding: 24px 32px; }
        .admin-footer { background: #ffffff; border-top: 1px solid #e2e8f0; padding: 16px; text-align: center; font-size: 12px; color: #64748b; }
    </style>
    <sitemesh:write property='head'/>
</head>
<body>

    <header class="admin-header">
        <a href="${pageContext.request.contextPath}/admin/categories" class="admin-brand">
            ⚡ BT01 Admin Dashboard
        </a>
        <ul class="admin-nav-links">
            <li><a href="${pageContext.request.contextPath}/home" target="_blank">🌐 Xem trang Public</a></li>
            <li><a href="${pageContext.request.contextPath}/profile">👤 Hồ sơ cá nhân</a></li>
            <li><a href="${pageContext.request.contextPath}/logout" style="color: #f87171;">Đăng xuất</a></li>
        </ul>
    </header>

    <div class="admin-layout">
        <aside class="admin-sidebar">
            <div class="sidebar-title">Quản trị hệ thống</div>
            <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link">📁 Quản lý Danh mục</a>
            <a href="${pageContext.request.contextPath}/admin/category/add" class="sidebar-link">➕ Thêm Danh mục</a>
            <a href="${pageContext.request.contextPath}/admin/products" class="sidebar-link">📦 Quản lý Sản phẩm</a>
            <a href="${pageContext.request.contextPath}/admin/product/add" class="sidebar-link">➕ Thêm Sản phẩm</a>
            
            <div class="sidebar-title" style="margin-top: 20px;">Tài khoản</div>
            <a href="${pageContext.request.contextPath}/profile" class="sidebar-link">👤 Thông tin cá nhân</a>
        </aside>

        <main class="admin-content">
            <sitemesh:write property='body'/>
        </main>
    </div>

    <footer class="admin-footer">
        <p>&copy; 2026 BT01 Shopping Management Panel</p>
    </footer>

</body>
</html>
