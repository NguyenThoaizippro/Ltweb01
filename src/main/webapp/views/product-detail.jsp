<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} - Chi tiết sản phẩm</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background: #f8fafc; color: #1e293b; }
        .container { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
        .breadcrumb { margin-bottom: 20px; font-size: 14px; color: #64748b; }
        .breadcrumb a { color: #2563eb; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        .product-detail-card {
            background: #fff; border-radius: 12px; box-shadow: 0 4px 16px rgba(0,0,0,0.06);
            display: grid; grid-template-columns: 1fr 1fr; gap: 40px; padding: 36px;
        }
        @media (max-width: 768px) { .product-detail-card { grid-template-columns: 1fr; } }
        .detail-img-box { width: 100%; height: 380px; background: #f1f5f9; border-radius: 8px; overflow: hidden; display: flex; align-items: center; justify-content: center; }
        .detail-img-box img { width: 100%; height: 100%; object-fit: cover; }
        .detail-info { display: flex; flex-direction: column; }
        .detail-category { font-size: 13px; color: #64748b; text-transform: uppercase; font-weight: 700; margin-bottom: 8px; letter-spacing: 0.5px; }
        .detail-title { font-size: 26px; font-weight: 700; color: #0f172a; margin-bottom: 16px; line-height: 1.3; }
        .detail-price { font-size: 28px; font-weight: 700; color: #dc2626; margin-bottom: 24px; }
        .detail-desc-title { font-size: 15px; font-weight: 600; color: #334155; margin-bottom: 8px; }
        .detail-desc { font-size: 14px; line-height: 1.6; color: #475569; margin-bottom: 30px; white-space: pre-line; }
        .detail-meta { font-size: 13px; color: #94a3b8; margin-top: auto; padding-top: 16px; border-top: 1px solid #e2e8f0; }
        .btn-back { display: inline-block; padding: 10px 20px; background: #e2e8f0; color: #334155; text-decoration: none; border-radius: 6px; font-weight: 600; font-size: 14px; margin-top: 20px; width: fit-content; }
        .btn-back:hover { background: #cbd5e1; }
    </style>
</head>
<body>

<%@ include file="/views/topbar.jsp" %>

<div class="container">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/home">Trang chủ</a> &gt; 
        <a href="${pageContext.request.contextPath}/product">Sản phẩm</a> &gt; 
        <span>${product.productName}</span>
    </div>

    <div class="product-detail-card">
        <div class="detail-img-box">
            <c:choose>
                <c:when test="${product.images != null && fn:startsWith(product.images, 'http')}">
                    <img src="${product.images}" alt="${product.productName}">
                </c:when>
                <c:otherwise>
                    <img src="<c:url value='/image?fname=${product.images}'/>" alt="${product.productName}">
                </c:otherwise>
            </c:choose>
        </div>

        <div class="detail-info">
            <div class="detail-category">Danh mục: ${product.category.categoryname}</div>
            <h1 class="detail-title">${product.productName}</h1>
            <div class="detail-price">${product.price} VNĐ</div>

            <div class="detail-desc-title">Mô tả sản phẩm:</div>
            <div class="detail-desc">
                <c:choose>
                    <c:when test="${not empty product.description}">
                        ${product.description}
                    </c:when>
                    <c:otherwise>
                        Chưa có mô tả chi tiết cho sản phẩm này.
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="detail-meta">
                Mã sản phẩm: #${product.productId} | Ngày đăng: ${product.createDate}
            </div>

            <a href="${pageContext.request.contextPath}/product" class="btn-back">← Quay lại danh sách sản phẩm</a>
        </div>
    </div>
</div>

</body>
</html>
