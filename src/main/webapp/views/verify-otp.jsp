<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực mã OTP - BT01</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .card { background: #fff; padding: 32px 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); width: 100%; max-width: 440px; text-align: center; }
        h2 { margin-bottom: 12px; color: #1a1a1a; }
        .desc { font-size: 14px; color: #4b5563; margin-bottom: 20px; line-height: 1.5; }
        .alert { background: #fee2e2; border-left: 4px solid #ef4444; color: #991b1b; padding: 12px; border-radius: 4px; margin-bottom: 20px; font-size: 14px; text-align: left; }
        .msg { background: #dcfce7; border-left: 4px solid #22c55e; color: #166534; padding: 12px; border-radius: 4px; margin-bottom: 20px; font-size: 14px; text-align: left; }
        .otp-input {
            width: 100%; font-size: 26px; letter-spacing: 12px; text-align: center; font-weight: 700; padding: 12px;
            border: 2px solid #3b82f6; border-radius: 8px; margin-bottom: 16px; outline: none;
        }
        .btn-submit {
            width: 100%; padding: 12px; background: #2563eb; color: #fff; border: none; border-radius: 6px; font-weight: 600; font-size: 15px; cursor: pointer; transition: background 0.2s;
        }
        .btn-submit:hover { background: #1d4ed8; }
        .timer-info { font-size: 13px; color: #ef4444; margin-top: 14px; font-weight: 500; }
        .resend-box { margin-top: 20px; padding-top: 16px; border-top: 1px solid #e5e7eb; font-size: 14px; color: #6b7280; }
        .btn-resend { background: none; border: none; color: #2563eb; font-weight: 600; cursor: pointer; text-decoration: underline; font-size: 14px; }
        .btn-resend:disabled { color: #9ca3af; cursor: not-allowed; text-decoration: none; }
        .links { margin-top: 16px; }
        .links a { color: #6b7280; text-decoration: none; font-size: 13px; }
        .links a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="card">
    <h2>Xác thực mã OTP</h2>
    <p class="desc">
        Mã OTP 6 chữ số đã được gửi đến email:<br/>
        <strong style="color:#1d4ed8;">${email}</strong>
    </p>

    <c:if test="${alert != null}">
        <div class="alert">${alert}</div>
    </c:if>
    <c:if test="${msg != null}">
        <div class="msg">${msg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/verify-otp" method="post">
        <input type="hidden" name="email" value="${email}">
        <input type="hidden" name="purpose" value="${purpose}">

        <input type="text" name="otp" class="otp-input" maxlength="6" pattern="[0-9]{6}" inputmode="numeric" placeholder="------" required autofocus>

        <button type="submit" class="btn-submit">Xác nhận mã OTP</button>
    </form>

    <div class="timer-info" id="expiryNotice">
        Mã có hiệu lực trong <span id="expiryCount">120</span> giây
    </div>

    <div class="resend-box">
        Chưa nhận được mã?
        <form action="${pageContext.request.contextPath}/resend-otp" method="post" style="display:inline;">
            <input type="hidden" name="email" value="${email}">
            <input type="hidden" name="purpose" value="${purpose}">
            <button type="submit" id="resendBtn" class="btn-resend" disabled>Gửi lại (<span id="cooldownCount">60</span>s)</button>
        </form>
    </div>

    <div class="links">
        <a href="${pageContext.request.contextPath}/login">← Quay lại Đăng nhập</a>
    </div>
</div>

<script>
    let cooldown = 60;
    const resendBtn = document.getElementById('resendBtn');
    const cooldownCount = document.getElementById('cooldownCount');
    const cooldownTimer = setInterval(() => {
        cooldown--;
        if (cooldown <= 0) {
            clearInterval(cooldownTimer);
            resendBtn.disabled = false;
            resendBtn.innerText = 'Gửi lại mã OTP';
        } else {
            cooldownCount.innerText = cooldown;
        }
    }, 1000);

    let expiry = 120;
    const expiryCount = document.getElementById('expiryCount');
    const expiryNotice = document.getElementById('expiryNotice');
    const expiryTimer = setInterval(() => {
        expiry--;
        if (expiry <= 0) {
            clearInterval(expiryTimer);
            expiryNotice.innerText = 'Mã OTP đã hết hạn! Vui lòng bấm Gửi lại mã.';
        } else {
            expiryCount.innerText = expiry;
        }
    }, 1000);
</script>

</body>
</html>
