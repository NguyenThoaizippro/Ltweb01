<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
</head>
<body>

<h1>Đăng nhập</h1>

<c:if test="${alert != null}">
    <h3 style="color: red;">${alert}</h3>
</c:if>

<form action="${pageContext.request.contextPath}/login" method="post">
    <p>
        <label>Tài khoản:</label>
        <input type="text" name="username" required>
    </p>
    <p>
        <label>Mật khẩu:</label>
        <input type="password" name="password" required>
    </p>
    <p>
        <input type="checkbox" name="remember">
        Ghi nhớ đăng nhập
    </p>
    <button type="submit">Đăng nhập</button>
</form>

</body>
</html>
