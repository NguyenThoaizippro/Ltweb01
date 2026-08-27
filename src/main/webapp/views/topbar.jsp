<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div style="margin-bottom: 20px; padding: 10px; background-color: #f8f9fa; border-bottom: 1px solid #ddd;">
<c:choose>
    <c:when test="${sessionScope.account == null}">
        <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
    </c:when>
    <c:otherwise>
        Xin chào, <b>${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.userName}</b>
        |
        <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
    </c:otherwise>
</c:choose>
</div>
