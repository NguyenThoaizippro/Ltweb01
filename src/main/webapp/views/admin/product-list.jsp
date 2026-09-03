<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Sản phẩm - Admin</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 20px; background: #f9fafb; color: #1f2937; }
        .nav-bar { margin: 15px 0; display: flex; gap: 12px; align-items: center; }
        .nav-bar a { text-decoration: none; padding: 8px 14px; border-radius: 6px; font-weight: 500; font-size: 14px; }
        .btn-add { background: #2563eb; color: #fff; }
        .btn-back { background: #e5e7eb; color: #374151; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.1); margin-top: 15px; }
        th, td { padding: 12px 16px; text-align: left; border-bottom: 1px solid #e5e7eb; font-size: 14px; }
        th { background: #f3f4f6; font-weight: 600; color: #374151; }
        tr:hover { background: #f9fafb; }
        .prod-img { width: 80px; height: 60px; object-fit: cover; border-radius: 4px; border: 1px solid #e5e7eb; }
        .badge-active { background: #dcfce7; color: #166534; padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: 600; }
        .badge-locked { background: #fee2e2; color: #991b1b; padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: 600; }
        .action-links a { text-decoration: none; font-weight: 500; margin-right: 8px; }
        .action-links a.edit { color: #2563eb; }
        .action-links a.delete { color: #dc2626; }
    </style>
</head>
<body>

<%@ include file="/views/topbar.jsp" %>

<h2>Quản lý Danh sách Sản phẩm</h2>

<div class="nav-bar">
    <a href="<c:url value='/admin/product/add'/>" class="btn-add">➕ Thêm Sản phẩm Mới</a>
    <a href="<c:url value='/admin/categories'/>" class="btn-back">📁 Quản lý Danh mục</a>
    <a href="<c:url value='/product'/>" class="btn-back" target="_blank">🌐 Xem trang Public</a>
</div>

<table>
    <thead>
        <tr>
            <th style="width: 50px;">STT</th>
            <th style="width: 100px;">Hình ảnh</th>
            <th>Tên sản phẩm</th>
            <th>Danh mục</th>
            <th>Giá bán (VNĐ)</th>
            <th>Trạng thái</th>
            <th style="width: 140px;">Thao tác</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach items="${listProduct}" var="prod" varStatus="stt">
            <tr>
                <td>${stt.index + 1}</td>
                <td>
                    <c:choose>
                        <c:when test="${prod.images != null && fn:startsWith(prod.images, 'http')}">
                            <img src="${prod.images}" class="prod-img" alt="${prod.productName}">
                        </c:when>
                        <c:otherwise>
                            <img src="<c:url value='/image?fname=${prod.images}'/>" class="prod-img" alt="${prod.productName}">
                        </c:otherwise>
                    </c:choose>
                </td>
                <td><strong>${prod.productName}</strong></td>
                <td>${prod.category.categoryname}</td>
                <td><strong style="color: #059669;">${prod.price}</strong></td>
                <td>
                    <c:choose>
                        <c:when test="${prod.status == 1}">
                            <span class="badge-active">Hoạt động</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-locked">Tạm khóa</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td class="action-links">
                    <a href="<c:url value='/admin/product/edit?id=${prod.productId}'/>" class="edit">Sửa</a>
                    <a href="<c:url value='/admin/product/delete?id=${prod.productId}'/>" class="delete" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">Xóa</a>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty listProduct}">
            <tr>
                <td colspan="7" style="text-align: center; color: #6b7280; padding: 24px;">Chưa có sản phẩm nào. Hãy bấm "Thêm Sản phẩm Mới" để tạo!</td>
            </tr>
        </c:if>
    </tbody>
</table>

</body>
</html>
