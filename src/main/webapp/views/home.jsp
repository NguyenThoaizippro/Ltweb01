<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - BT01 Shopping</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background: #f8fafc; color: #1e293b; }
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; border-bottom: 2px solid #e2e8f0; padding-bottom: 12px; }
        .section-title { font-size: 22px; font-weight: 700; color: #0f172a; display: flex; align-items: center; gap: 8px; }
        .view-all { color: #2563eb; text-decoration: none; font-weight: 600; font-size: 15px; }
        .view-all:hover { text-decoration: underline; }
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(210px, 1fr)); gap: 20px; }
        .product-card {
            background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            transition: transform 0.2s, box-shadow 0.2s; display: flex; flex-direction: column; text-decoration: none; color: inherit;
        }
        .product-card:hover { transform: translateY(-4px); box-shadow: 0 8px 16px rgba(0,0,0,0.1); }
        .img-wrap { width: 100%; height: 180px; overflow: hidden; background: #f1f5f9; display: flex; align-items: center; justify-content: center; }
        .img-wrap img { width: 100%; height: 100%; object-fit: cover; }
        .card-body { padding: 14px; display: flex; flex-direction: column; flex-grow: 1; }
        .card-category { font-size: 12px; color: #64748b; margin-bottom: 6px; text-transform: uppercase; font-weight: 600; }
        .card-title { font-size: 15px; font-weight: 600; margin-bottom: 10px; line-height: 1.4; color: #1e293b; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .card-price { margin-top: auto; font-size: 16px; font-weight: 700; color: #dc2626; }
        .hero { background: linear-gradient(135deg, #1e3a8a, #3b82f6); color: #fff; padding: 40px 20px; text-align: center; border-radius: 12px; margin-bottom: 30px; }
        .hero h1 { margin-bottom: 10px; font-size: 32px; }
        .hero p { font-size: 16px; opacity: 0.9; }
    </style>
</head>
<body>


<div class="container">
    <div class="hero">
        <h1>Chào mừng đến với BT01 Shopping</h1>
        <p>Hệ thống mua sắm trực tuyến hiện đại, bảo mật với xác thực OTP và danh mục phong phú.</p>
    </div>

    <div class="section-header">
        <div class="section-title">✨ 10 Sản phẩm mới nhất</div>
        <a href="${pageContext.request.contextPath}/product" class="view-all">Xem tất cả sản phẩm →</a>
    </div>

    <div class="product-grid">
        <c:forEach items="${top10}" var="p">
            <a href="${pageContext.request.contextPath}/product/detail?id=${p.productId}" class="product-card">
                <div class="img-wrap">
                    <c:choose>
                        <c:when test="${p.images != null && fn:startsWith(p.images, 'http')}">
                            <img src="${p.images}" alt="${p.productName}">
                        </c:when>
                        <c:otherwise>
                            <img src="<c:url value='/image?fname=${p.images}'/>" alt="${p.productName}">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="card-body">
                    <div class="card-category">${p.category.categoryname}</div>
                    <div class="card-title">${p.productName}</div>
                    <div class="card-price">${p.price} VNĐ</div>
                </div>
            </a>
        </c:forEach>
        <c:if test="${empty top10}">
            <p style="grid-column: 1 / -1; text-align: center; color: #64748b; padding: 30px;">Hiện chưa có sản phẩm nào được hiển thị.</p>
        </c:if>
    </div>
</div>

</body>
</html>
