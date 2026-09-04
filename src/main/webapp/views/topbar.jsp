<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<div style="margin-bottom: 20px; padding: 10px 20px; background-color: #f8f9fa; border-bottom: 1px solid #ddd; display: flex; justify-content: space-between; align-items: center;">
    <div>
        <a href="${pageContext.request.contextPath}/home" style="text-decoration: none; font-weight: 700; color: #2563eb;">🛒 BT01 Shopping</a>
        <span style="margin: 0 10px; color: #cbd5e1;">|</span>
        <a href="${pageContext.request.contextPath}/product" style="text-decoration: none; color: #475569;">Sản phẩm</a>
    </div>
    <div style="display: flex; align-items: center; gap: 12px;">
<c:choose>
    <c:when test="${sessionScope.account == null}">
        <a href="${pageContext.request.contextPath}/login" style="color: #2563eb; text-decoration: none; font-weight: 600;">Đăng nhập</a>
    </c:when>
    <c:otherwise>
        <a href="${pageContext.request.contextPath}/profile" style="display: flex; align-items: center; gap: 8px; text-decoration: none; color: #1e293b;">
            <c:choose>
                <c:when test="${sessionScope.account.avatar != null && fn:startsWith(sessionScope.account.avatar, 'http')}">
                    <img src="${sessionScope.account.avatar}" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover;" alt="Avatar">
                </c:when>
                <c:when test="${sessionScope.account.avatar != null && !empty sessionScope.account.avatar}">
                    <img src="<c:url value='/image?fname=${sessionScope.account.avatar}'/>" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover;" alt="Avatar">
                </c:when>
                <c:otherwise>
                    <img src="https://ui-avatars.com/api/?name=${sessionScope.account.userName}&background=3b82f6&color=fff" style="width: 28px; height: 28px; border-radius: 50%;" alt="Avatar">
                </c:otherwise>
            </c:choose>
            <span>Xin chào, <b>${not empty sessionScope.account.fullName ? sessionScope.account.fullName : sessionScope.account.userName}</b></span>
        </a>
        <span style="color: #cbd5e1;">|</span>
        <a href="${pageContext.request.contextPath}/profile" style="color: #2563eb; text-decoration: none; font-size: 13px;">Hồ sơ</a>
        <span style="color: #cbd5e1;">|</span>
        <a href="${pageContext.request.contextPath}/logout" style="color: #ef4444; text-decoration: none; font-size: 13px;">Đăng xuất</a>
    </c:otherwise>
</c:choose>
    </div>
</div>
