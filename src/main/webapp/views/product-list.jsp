<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách sản phẩm - BT01 Shopping</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background: #f8fafc; color: #1e293b; }
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .page-header { margin-bottom: 24px; border-bottom: 2px solid #e2e8f0; padding-bottom: 12px; display: flex; justify-content: space-between; align-items: center; }
        .page-title { font-size: 24px; font-weight: 700; color: #0f172a; }
        .product-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
        @media (max-width: 900px) { .product-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 600px) { .product-grid { grid-template-columns: 1fr; } }
        .product-card {
            background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            transition: transform 0.2s, box-shadow 0.2s; display: flex; flex-direction: column; text-decoration: none; color: inherit;
        }
        .product-card:hover { transform: translateY(-4px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .img-wrap { width: 100%; height: 220px; overflow: hidden; background: #f1f5f9; display: flex; align-items: center; justify-content: center; }
        .img-wrap img { width: 100%; height: 100%; object-fit: cover; }
        .card-body { padding: 18px; display: flex; flex-direction: column; flex-grow: 1; }
        .card-category { font-size: 13px; color: #64748b; margin-bottom: 6px; text-transform: uppercase; font-weight: 600; }
        .card-title { font-size: 17px; font-weight: 600; margin-bottom: 12px; line-height: 1.4; color: #1e293b; }
        .card-desc { font-size: 13px; color: #64748b; margin-bottom: 16px; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .card-price { margin-top: auto; font-size: 18px; font-weight: 700; color: #dc2626; }
        
        .pagination { display: flex; justify-content: center; align-items: center; gap: 8px; margin: 40px 0; }
        .pagination a, .pagination span {
            padding: 8px 14px; border-radius: 6px; text-decoration: none; font-size: 14px; font-weight: 500;
        }
        .pagination a { background: #fff; color: #374151; border: 1px solid #d1d5db; transition: all 0.2s; }
        .pagination a:hover { background: #f3f4f6; border-color: #9ca3af; }
        .pagination .active { background: #2563eb; color: #fff; border: 1px solid #2563eb; font-weight: 700; }
        .pagination .disabled { color: #9ca3af; background: #f9fafb; border: 1px solid #e5e7eb; cursor: not-allowed; }
    </style>
</head>
<body>


<div class="container">
    <div class="page-header">
        <div class="page-title">🛍️ Tất cả sản phẩm</div>
        <a href="${pageContext.request.contextPath}/home" style="color: #2563eb; text-decoration: none; font-size: 14px;">← Quay lại Trang chủ</a>
    </div>

    <div class="product-grid">
        <c:forEach items="${listProduct}" var="p">
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
                    <c:if test="${not empty p.description}">
                        <div class="card-desc">${p.description}</div>
                    </c:if>
                    <div class="card-price">${p.price} VNĐ</div>
                </div>
            </a>
        </c:forEach>
        <c:if test="${empty listProduct}">
            <p style="grid-column: 1 / -1; text-align: center; color: #64748b; padding: 40px;">Không có sản phẩm nào trên trang này.</p>
        </c:if>
    </div>

    <!-- Phân trang 6 sp / trang -->
    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:choose>
                <c:when test="${currentPage > 0}">
                    <a href="?page=${currentPage - 1}">« Trước</a>
                </c:when>
                <c:otherwise>
                    <span class="disabled">« Trước</span>
                </c:otherwise>
            </c:choose>

            <c:forEach begin="0" end="${totalPages - 1}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span class="active">${i + 1}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="?page=${i}">${i + 1}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:choose>
                <c:when test="${currentPage < totalPages - 1}">
                    <a href="?page=${currentPage + 1}">Sau »</a>
                </c:when>
                <c:otherwise>
                    <span class="disabled">Sau »</span>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>
</div>

</body>
</html>
