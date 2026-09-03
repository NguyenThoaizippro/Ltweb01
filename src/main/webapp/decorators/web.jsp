<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> | BT01 Shopping</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, Roboto, sans-serif; background: #f8fafc; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; }
        
        /* Global Header */
        .site-header { background: #ffffff; border-bottom: 1px solid #e2e8f0; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 3px rgba(0,0,0,0.04); }
        .header-inner { max-width: 1200px; margin: 0 auto; padding: 12px 20px; display: flex; justify-content: space-between; align-items: center; }
        .brand { font-size: 20px; font-weight: 800; color: #2563eb; text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .nav-links { display: flex; align-items: center; gap: 20px; list-style: none; }
        .nav-links a { text-decoration: none; color: #475569; font-weight: 500; font-size: 14px; transition: color 0.2s; }
        .nav-links a:hover { color: #2563eb; }
        
        /* User account section */
        .user-nav { display: flex; align-items: center; gap: 12px; }
        .user-avatar-sm { width: 34px; height: 34px; border-radius: 50%; object-fit: cover; border: 2px solid #3b82f6; vertical-align: middle; }
        .user-greeting { font-size: 14px; font-weight: 600; color: #1e293b; display: flex; align-items: center; gap: 8px; text-decoration: none; }
        .btn-logout { font-size: 13px; color: #ef4444; text-decoration: none; padding: 6px 12px; border: 1px solid #fecaca; border-radius: 6px; transition: background 0.2s; }
        .btn-logout:hover { background: #fee2e2; }
        .btn-login { font-size: 14px; color: #ffffff; background: #2563eb; text-decoration: none; padding: 7px 16px; border-radius: 6px; font-weight: 600; }
        .btn-login:hover { background: #1d4ed8; }

        /* Main Content Container */
        .site-body { flex: 1; width: 100%; }

        /* Global Footer */
        .site-footer { background: #ffffff; border-top: 1px solid #e2e8f0; padding: 24px 20px; margin-top: 40px; text-align: center; font-size: 13px; color: #64748b; }
        .footer-links { margin-bottom: 8px; display: flex; justify-content: center; gap: 16px; }
        .footer-links a { color: #64748b; text-decoration: none; }
        .footer-links a:hover { color: #2563eb; }
    </style>
    <sitemesh:write property='head'/>
</head>
<body>

    <header class="site-header">
        <div class="header-inner">
            <a href="${pageContext.request.contextPath}/home" class="brand">
                🛒 BT01 Shopping
            </a>

            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/product">Sản phẩm</a></li>
                <c:if test="${sessionScope.account != null && sessionScope.account.roleid == 1}">
                    <li><a href="${pageContext.request.contextPath}/admin/categories" style="color: #7c3aed; font-weight: 700;">⚙️ Quản trị</a></li>
                </c:if>
            </ul>

            <div class="user-nav">
                <c:choose>
                    <c:when test="${sessionScope.account != null}">
                        <a href="${pageContext.request.contextPath}/profile" class="user-greeting" title="Xem hồ sơ cá nhân">
                            <c:choose>
                                <c:when test="${sessionScope.account.avatar != null && fn:startsWith(sessionScope.account.avatar, 'http')}">
                                    <img src="${sessionScope.account.avatar}" class="user-avatar-sm" alt="Avatar">
                                </c:when>
                                <c:when test="${sessionScope.account.avatar != null && !empty sessionScope.account.avatar}">
                                    <img src="<c:url value='/image?fname=${sessionScope.account.avatar}'/>" class="user-avatar-sm" alt="Avatar">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://ui-avatars.com/api/?name=${sessionScope.account.userName}&background=3b82f6&color=fff" class="user-avatar-sm" alt="Avatar">
                                </c:otherwise>
                            </c:choose>
                            <span>${not empty sessionScope.account.fullName ? sessionScope.account.fullName : sessionScope.account.userName}</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/profile" style="font-size:13px; color:#2563eb; text-decoration:none;">Hồ sơ</a>
                        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn-login">Đăng nhập</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <main class="site-body">
        <sitemesh:write property='body'/>
    </main>

    <footer class="site-footer">
        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/product">Sản phẩm</a>
            <a href="${pageContext.request.contextPath}/profile">Hồ sơ cá nhân</a>
        </div>
        <p>&copy; 2026 BT01 Shopping - Lập Trình Web Servlet & JPA. All rights reserved.</p>
    </footer>

</body>
</html>
