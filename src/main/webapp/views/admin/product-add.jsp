<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Sản phẩm - Admin</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 20px; background: #f9fafb; color: #1f2937; }
        .container { max-width: 650px; margin: 20px auto; background: #fff; padding: 28px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        h2 { margin-bottom: 20px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 6px; font-weight: 500; font-size: 14px; }
        input[type="text"], input[type="number"], select, textarea {
            width: 100%; padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px; box-sizing: border-box;
        }
        textarea { resize: vertical; height: 90px; }
        .radio-group { display: flex; gap: 20px; align-items: center; margin-top: 6px; }
        .btn-group { display: flex; gap: 10px; margin-top: 24px; }
        .btn-submit { padding: 10px 20px; background: #2563eb; color: #fff; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; }
        .btn-cancel { padding: 10px 20px; background: #e5e7eb; color: #374151; text-decoration: none; border-radius: 6px; font-weight: 500; font-size: 14px; display: inline-block; }
    </style>
</head>
<body>

<%@ include file="/views/topbar.jsp" %>

<div class="container">
    <h2>Thêm Sản phẩm Mới</h2>

    <form action="${pageContext.request.contextPath}/admin/product/insert" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label for="productName">Tên sản phẩm (*):</label>
            <input type="text" id="productName" name="productName" required autofocus>
        </div>

        <div class="form-group">
            <label for="categoryId">Danh mục (*):</label>
            <select id="categoryId" name="categoryId" required>
                <c:forEach items="${categories}" var="c">
                    <option value="${c.categoryid}">${c.categoryname}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="price">Giá bán (VNĐ) (*):</label>
            <input type="number" id="price" name="price" step="1000" min="0" required placeholder="100000">
        </div>

        <div class="form-group">
            <label for="description">Mô tả sản phẩm:</label>
            <textarea id="description" name="description" placeholder="Nhập thông tin chi tiết về sản phẩm..."></textarea>
        </div>

        <div class="form-group">
            <label for="images1">Tải ảnh lên từ máy tính (Tối đa 5MB):</label>
            <input type="file" id="images1" name="images1" accept="image/*">
        </div>

        <div class="form-group">
            <label for="images">Hoặc nhập liên kết ảnh trực tiếp (URL):</label>
            <input type="text" id="images" name="images" placeholder="https://example.com/image.jpg">
        </div>

        <div class="form-group">
            <label>Trạng thái:</label>
            <div class="radio-group">
                <label><input type="radio" name="status" value="1" checked> Hoạt động</label>
                <label><input type="radio" name="status" value="0"> Khóa</label>
            </div>
        </div>

        <div class="btn-group">
            <button type="submit" class="btn-submit">Lưu sản phẩm</button>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn-cancel">Hủy bỏ</a>
        </div>
    </form>
</div>

</body>
</html>
