<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa Sản phẩm - Admin</title>
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
        .img-preview { max-width: 140px; max-height: 100px; object-fit: cover; border-radius: 4px; border: 1px solid #d1d5db; margin-top: 6px; }
    </style>
</head>
<body>

<%@ include file="/views/topbar.jsp" %>

<div class="container">
    <h2>Chỉnh sửa Sản phẩm #${product.productId}</h2>

    <form action="${pageContext.request.contextPath}/admin/product/update" method="post" enctype="multipart/form-data">
        <input type="hidden" name="productId" value="${product.productId}">

        <div class="form-group">
            <label for="productName">Tên sản phẩm (*):</label>
            <input type="text" id="productName" name="productName" value="${product.productName}" required autofocus>
        </div>

        <div class="form-group">
            <label for="categoryId">Danh mục (*):</label>
            <select id="categoryId" name="categoryId" required>
                <c:forEach items="${categories}" var="c">
                    <option value="${c.categoryid}" ${c.categoryid == product.category.categoryid ? 'selected' : ''}>
                        ${c.categoryname}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="price">Giá bán (VNĐ) (*):</label>
            <input type="number" id="price" name="price" value="${product.price}" step="1000" min="0" required>
        </div>

        <div class="form-group">
            <label for="description">Mô tả sản phẩm:</label>
            <textarea id="description" name="description">${product.description}</textarea>
        </div>

        <div class="form-group">
            <label>Hình ảnh hiện tại:</label>
            <div>
                <c:choose>
                    <c:when test="${product.images != null && fn:startsWith(product.images, 'http')}">
                        <img src="${product.images}" class="img-preview" alt="Current image">
                    </c:when>
                    <c:otherwise>
                        <img src="<c:url value='/image?fname=${product.images}'/>" class="img-preview" alt="Current image">
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="form-group">
            <label for="images1">Thay đổi ảnh bằng file mới (Tối đa 5MB):</label>
            <input type="file" id="images1" name="images1" accept="image/*">
        </div>

        <div class="form-group">
            <label for="images">Hoặc đổi sang liên kết ảnh URL mới:</label>
            <input type="text" id="images" name="images" value="${product.images}">
        </div>

        <div class="form-group">
            <label>Trạng thái:</label>
            <div class="radio-group">
                <label><input type="radio" name="status" value="1" ${product.status == 1 ? 'checked' : ''}> Hoạt động</label>
                <label><input type="radio" name="status" value="0" ${product.status == 0 ? 'checked' : ''}> Khóa</label>
            </div>
        </div>

        <div class="btn-group">
            <button type="submit" class="btn-submit">Cập nhật sản phẩm</button>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn-cancel">Hủy bỏ</a>
        </div>
    </form>
</div>

</body>
</html>
