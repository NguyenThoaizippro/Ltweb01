<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - BT01</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .card { background: #fff; padding: 32px 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); width: 100%; max-width: 440px; }
        h2 { margin-bottom: 12px; color: #1a1a1a; text-align: center; }
        .desc { font-size: 14px; color: #6b7280; text-align: center; margin-bottom: 20px; }
        .alert { background: #fee2e2; border-left: 4px solid #ef4444; color: #991b1b; padding: 12px; border-radius: 4px; margin-bottom: 20px; font-size: 14px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 6px; font-weight: 500; color: #374151; font-size: 14px; }
        input[type="password"] {
            width: 100%; padding: 10px 14px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px; transition: border-color 0.2s;
        }
        input:focus { outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.15); }
        .btn-submit {
            width: 100%; padding: 12px; background: #2563eb; color: #fff; border: none; border-radius: 6px; font-weight: 600; font-size: 15px; cursor: pointer; transition: background 0.2s;
        }
        .btn-submit:hover { background: #1d4ed8; }
        .links { margin-top: 20px; text-align: center; font-size: 14px; }
        .links a { color: #2563eb; text-decoration: none; font-weight: 500; }
        .links a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="card">
    <h2>Đặt lại mật khẩu</h2>
    <p class="desc">Nhập mật khẩu mới cho tài khoản của bạn.</p>

    <c:if test="${alert != null}">
        <div class="alert">${alert}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/reset-password" method="post">
        <div class="form-group">
            <label for="password">Mật khẩu mới:</label>
            <input type="password" id="password" name="password" required autofocus minlength="4">
        </div>

        <div class="form-group">
            <label for="confirmPassword">Xác nhận mật khẩu mới:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required minlength="4">
        </div>

        <button type="submit" class="btn-submit">Lưu mật khẩu mới</button>
    </form>

    <div class="links">
        <a href="${pageContext.request.contextPath}/login">← Hủy và quay lại Đăng nhập</a>
    </div>
</div>

</body>
</html>
