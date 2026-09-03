<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân</title>
    <style>
        .profile-container { max-width: 800px; margin: 30px auto; padding: 0 20px; }
        .profile-card { background: #ffffff; border-radius: 12px; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); overflow: hidden; }
        .profile-header-banner { background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); padding: 32px 30px; color: #fff; display: flex; align-items: center; gap: 24px; }
        .avatar-wrapper { position: relative; }
        .profile-avatar-large { width: 96px; height: 96px; border-radius: 50%; object-fit: cover; border: 4px solid #ffffff; box-shadow: 0 2px 8px rgba(0,0,0,0.2); background: #f1f5f9; }
        .header-meta h2 { font-size: 22px; font-weight: 700; margin-bottom: 4px; }
        .header-meta p { font-size: 14px; opacity: 0.9; }
        .role-badge { display: inline-block; font-size: 12px; font-weight: 600; padding: 2px 10px; border-radius: 12px; background: rgba(255,255,255,0.2); margin-top: 6px; }

        .profile-body { padding: 30px; }
        .alert-success { background: #dcfce7; border-left: 4px solid #22c55e; color: #166534; padding: 12px 16px; border-radius: 6px; margin-bottom: 24px; font-size: 14px; }
        .alert-error { background: #fee2e2; border-left: 4px solid #ef4444; color: #991b1b; padding: 12px 16px; border-radius: 6px; margin-bottom: 24px; font-size: 14px; }

        .form-section-title { font-size: 16px; font-weight: 700; color: #1e293b; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 1px solid #f1f5f9; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 18px; }
        .form-group.full-width { grid-column: span 2; }
        .form-group label { font-size: 13px; font-weight: 600; color: #475569; }
        .form-group input { padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; transition: border-color 0.2s; outline: none; }
        .form-group input:focus { border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
        .form-group input:disabled, .form-group input[readonly] { background: #f8fafc; color: #64748b; cursor: not-allowed; }

        .file-upload-box { border: 2px dashed #cbd5e1; padding: 16px; border-radius: 8px; background: #f8fafc; text-align: center; cursor: pointer; transition: background 0.2s; }
        .file-upload-box:hover { background: #f1f5f9; }
        .file-upload-box input[type="file"] { display: none; }
        .upload-label { cursor: pointer; color: #2563eb; font-weight: 600; font-size: 14px; }
        .upload-hint { font-size: 12px; color: #94a3b8; margin-top: 4px; }

        .form-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px; padding-top: 20px; border-top: 1px solid #e2e8f0; }
        .btn-cancel { padding: 10px 20px; border: 1px solid #cbd5e1; background: #ffffff; color: #475569; border-radius: 6px; text-decoration: none; font-size: 14px; font-weight: 500; }
        .btn-cancel:hover { background: #f8fafc; }
        .btn-save { padding: 10px 24px; border: none; background: #2563eb; color: #ffffff; border-radius: 6px; font-size: 14px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .btn-save:hover { background: #1d4ed8; }

        @media (max-width: 640px) {
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full-width { grid-column: span 1; }
            .profile-header-banner { flex-direction: column; text-align: center; }
        }
    </style>
</head>
<body>

<div class="profile-container">
    <div class="profile-card">
        <!-- Banner Header -->
        <div class="profile-header-banner">
            <div class="avatar-wrapper">
                <c:choose>
                    <c:when test="${user.avatar != null && fn:startsWith(user.avatar, 'http')}">
                        <img id="avatarPreview" src="${user.avatar}" class="profile-avatar-large" alt="Avatar">
                    </c:when>
                    <c:when test="${user.avatar != null && !empty user.avatar}">
                        <img id="avatarPreview" src="<c:url value='/image?fname=${user.avatar}'/>" class="profile-avatar-large" alt="Avatar">
                    </c:when>
                    <c:otherwise>
                        <img id="avatarPreview" src="https://ui-avatars.com/api/?name=${user.userName}&background=ffffff&color=2563eb&size=128" class="profile-avatar-large" alt="Avatar">
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="header-meta">
                <h2>${not empty user.fullName ? user.fullName : user.userName}</h2>
                <p>@${user.userName} &bull; ${user.email}</p>
                <span class="role-badge">
                    <c:choose>
                        <c:when test="${user.roleid == 1}">Quản trị viên (Admin)</c:when>
                        <c:when test="${user.roleid == 2}">Quản lý (Manager)</c:when>
                        <c:otherwise>Khách hàng thành viên</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>

        <!-- Form Body -->
        <div class="profile-body">
            <c:if test="${not empty msg}">
                <div class="alert-success">✓ ${msg}</div>
            </c:if>
            <c:if test="${not empty alert}">
                <div class="alert-error">⚠ ${alert}</div>
            </c:if>

            <form action="<c:url value='/profile'/>" method="post" enctype="multipart/form-data">
                <div class="form-section-title">Thông tin tài khoản</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Tên đăng nhập (Username):</label>
                        <input type="text" value="${user.userName}" readonly disabled>
                    </div>
                    <div class="form-group">
                        <label>Địa chỉ Email:</label>
                        <input type="email" value="${user.email}" readonly disabled>
                    </div>
                    <div class="form-group">
                        <label>Trạng thái kích hoạt:</label>
                        <input type="text" value="${user.isActive == 1 ? 'Đã kích hoạt' : 'Chưa kích hoạt'}" readonly disabled>
                    </div>
                    <div class="form-group">
                        <label>Ngày tạo tài khoản:</label>
                        <input type="text" value="${user.createdDate}" readonly disabled>
                    </div>
                </div>

                <div class="form-section-title">Thông tin cá nhân (Có thể chỉnh sửa)</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="fullname">Họ và tên đầy đủ: <span style="color:#ef4444;">*</span></label>
                        <input type="text" id="fullname" name="fullname" value="${user.fullName}" placeholder="Nhập họ và tên..." required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Số điện thoại:</label>
                        <input type="text" id="phone" name="phone" value="${user.phone}" placeholder="Nhập số điện thoại...">
                    </div>
                    <div class="form-group full-width">
                        <label>Ảnh đại diện (Upload file mới hoặc nhập URL):</label>
                        <div class="file-upload-box" onclick="document.getElementById('fileInput').click()">
                            <input type="file" id="fileInput" name="images1" accept="image/*" onchange="previewImage(event)">
                            <div class="upload-label">📁 Bấm vào đây để chọn ảnh đại diện từ máy tính</div>
                            <div class="upload-hint">Hỗ trợ JPG, PNG, GIF, WEBP (tối đa 5MB)</div>
                            <div id="fileName" style="font-size: 13px; color: #2563eb; margin-top: 6px; font-weight: 600;"></div>
                        </div>
                    </div>
                    <div class="form-group full-width">
                        <label for="images">Hoặc đường dẫn ảnh online (URL):</label>
                        <input type="text" id="images" name="images" value="${fn:startsWith(user.avatar, 'http') ? user.avatar : ''}" placeholder="https://example.com/avatar.jpg">
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/home" class="btn-cancel">Hủy bỏ</a>
                    <button type="submit" class="btn-save">💾 Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function previewImage(event) {
    const input = event.target;
    if (input.files && input.files[0]) {
        const file = input.files[0];
        document.getElementById('fileName').innerText = 'Đã chọn file: ' + file.name + ' (' + (file.size / 1024).toFixed(1) + ' KB)';
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('avatarPreview').src = e.target.result;
        };
        reader.readAsDataURL(file);
    }
}
</script>

</body>
</html>
