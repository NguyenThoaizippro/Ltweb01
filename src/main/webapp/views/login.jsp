<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - BT01</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .card { background: #fff; padding: 32px 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); width: 100%; max-width: 440px; }
        h2 { margin-bottom: 24px; color: #1a1a1a; text-align: center; }
        .alert { background: #fee2e2; border-left: 4px solid #ef4444; color: #991b1b; padding: 12px; border-radius: 4px; margin-bottom: 20px; font-size: 14px; line-height: 1.4; }
        .success { background: #dcfce7; border-left: 4px solid #22c55e; color: #166534; padding: 12px; border-radius: 4px; margin-bottom: 20px; font-size: 14px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 6px; font-weight: 500; color: #374151; font-size: 14px; }
        input[type="text"], input[type="password"] {
            width: 100%; padding: 10px 14px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px; transition: border-color 0.2s;
        }
        input:focus { outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.15); }
        .checkbox-group { display: flex; align-items: center; gap: 8px; font-size: 14px; color: #4b5563; margin-bottom: 20px; }
        .btn-submit {
            width: 100%; padding: 12px; background: #2563eb; color: #fff; border: none; border-radius: 6px; font-weight: 600; font-size: 15px; cursor: pointer; transition: background 0.2s;
        }
        .btn-submit:hover { background: #1d4ed8; }
        .links { margin-top: 20px; display: flex; justify-content: space-between; font-size: 14px; }
        .links a { color: #2563eb; text-decoration: none; font-weight: 500; }
        .links a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="card">
    <h2>Đăng nhập</h2>

    <c:if test="${successMsg != null}">
        <div class="success">${successMsg}</div>
    </c:if>

    <c:if test="${alert != null}">
        <div class="alert">
            ${alert}
            <c:if test="${verifyUrl != null}">
                <div style="margin-top: 8px;">
                    <a href="${verifyUrl}" style="color: #1d4ed8; font-weight: 600; text-decoration: underline;">👉 Nhấp vào đây để xác thực OTP ngay</a>
                </div>
            </c:if>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="form-group">
            <label for="username">Tên đăng nhập hoặc Email:</label>
            <input type="text" id="username" name="username" value="${username}" required autofocus>
        </div>

        <div class="form-group">
            <label for="password">Mật khẩu:</label>
            <input type="password" id="password" name="password" required>
        </div>

        <div class="checkbox-group">
            <input type="checkbox" id="remember" name="remember">
            <label for="remember" style="margin-bottom:0; font-weight:normal;">Ghi nhớ đăng nhập</label>
        </div>

        <button type="submit" class="btn-submit">Đăng nhập</button>
    </form>

    <div class="links">
        <a href="${pageContext.request.contextPath}/register">Đăng ký tài khoản</a>
        <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
    </div>
</div>

</body>
</html>
