<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh mục sản phẩm - toi di ban hang</title>
    <style>
        .container {
            max-width: 1280px;
            margin: 32px auto 60px auto;
            padding: 0 24px;
        }

        /* Header trang danh sách */
        .catalog-header {
            margin-bottom: 28px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }
        .catalog-title {
            font-size: 28px;
            font-weight: 800;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: -0.5px;
        }
        .catalog-count-badge {
            font-size: 13px;
            font-weight: 700;
            background: #eff6ff;
            color: #2563eb;
            padding: 4px 12px;
            border-radius: 9999px;
            border: 1px solid #dbeafe;
        }

        /* Brand Quick Filter Bar */
        .filter-pills-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            overflow-x: auto;
            padding-bottom: 12px;
            margin-bottom: 32px;
        }
        .filter-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 18px;
            background: #ffffff;
            border: 1.5px solid #e2e8f0;
            border-radius: 9999px;
            color: #475569;
            text-decoration: none;
            font-weight: 600;
            font-size: 13.5px;
            white-space: nowrap;
            transition: all 0.2s ease;
        }
        .filter-pill:hover {
            border-color: #2563eb;
            color: #2563eb;
            background: #eff6ff;
        }
        .filter-pill.active {
            background: #2563eb;
            color: #ffffff;
            border-color: #2563eb;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.28);
        }

        /* Search banner alert */
        .search-alert {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #166534;
            padding: 12px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 14px;
        }
        .search-alert a {
            color: #15803d;
            font-weight: 700;
            text-decoration: underline;
        }

        /* Lưới sản phẩm */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 24px;
            margin-bottom: 48px;
        }

        /* Thẻ sản phẩm VIP */
        .product-card {
            background: #ffffff;
            border-radius: 18px;
            border: 1px solid rgba(226, 232, 240, 0.9);
            overflow: hidden;
            box-shadow: 0 4px 16px -2px rgba(15, 23, 42, 0.04);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            flex-direction: column;
            text-decoration: none;
            color: inherit;
            position: relative;
        }
        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 35px -4px rgba(15, 23, 42, 0.12);
            border-color: #cbd5e1;
        }

        .card-badge {
            position: absolute;
            top: 14px;
            left: 14px;
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: #ffffff;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 9px;
            border-radius: 6px;
            z-index: 2;
            box-shadow: 0 2px 6px rgba(37, 99, 235, 0.25);
            letter-spacing: 0.3px;
        }

        .img-wrap {
            width: 100%;
            height: 230px;
            background: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
            padding: 16px;
        }
        .img-wrap img {
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
            transition: transform 0.35s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .product-card:hover .img-wrap img {
            transform: scale(1.08);
        }

        .card-body {
            padding: 18px 20px 20px 20px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .card-category {
            font-size: 11.5px;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }
        .card-title {
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
            line-height: 1.35;
            margin-bottom: 8px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            min-height: 42px;
        }
        .card-desc {
            font-size: 12.5px;
            color: #64748b;
            line-height: 1.5;
            margin-bottom: 12px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .card-rating {
            display: flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            color: #f59e0b;
            margin-bottom: 12px;
            font-weight: 600;
        }
        .card-rating span.count {
            color: #94a3b8;
            font-weight: 500;
            margin-left: 2px;
        }

        .price-row {
            margin-top: auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 14px;
            border-top: 1px solid #f1f5f9;
        }
        .card-price {
            font-size: 18px;
            font-weight: 800;
            color: #ef4444;
            letter-spacing: -0.5px;
        }
        .card-btn {
            width: 36px;
            height: 36px;
            background: #eff6ff;
            color: #2563eb;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 15px;
            transition: all 0.2s;
        }
        .product-card:hover .card-btn {
            background: #2563eb;
            color: #ffffff;
            transform: rotate(-45deg);
        }

        /* Phân trang VIP */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-top: 30px;
        }
        .pagination a, .pagination span {
            min-width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0 14px;
            border-radius: 10px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .pagination a {
            background: #ffffff;
            color: #334155;
            border: 1.5px solid #e2e8f0;
        }
        .pagination a:hover {
            background: #eff6ff;
            border-color: #2563eb;
            color: #2563eb;
        }
        .pagination .active {
            background: #2563eb;
            color: #ffffff;
            border: 1.5px solid #2563eb;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }
        .pagination .disabled {
            color: #cbd5e1;
            background: #f8fafc;
            border: 1.5px solid #f1f5f9;
            cursor: not-allowed;
        }
    </style>
</head>
<body>

<div class="container">

    <!-- Header danh mục -->
    <div class="catalog-header">
        <div>
            <h1 class="catalog-title">
                <i class="bi bi-grid-3x3-gap-fill text-primary"></i> Danh Mục Điện Thoại Thông Minh
            </h1>
        </div>
        <div class="catalog-count-badge">
            <i class="bi bi-box-seam me-1"></i> ${totalCount} Sản phẩm khả dụng
        </div>
    </div>

    <!-- Thanh lọc nhanh theo Hãng -->
    <div class="filter-pills-bar">
        <a href="${pageContext.request.contextPath}/product" class="filter-pill ${empty selectedCatId && empty keyword ? 'active' : ''}">
            <i class="bi bi-collection"></i> Tất cả
        </a>
        <c:forEach items="${categories}" var="c">
            <a href="${pageContext.request.contextPath}/product?categoryId=${c.categoryid}" class="filter-pill ${selectedCatId == c.categoryid ? 'active' : ''}">
                <c:choose>
                    <c:when test="${fn:contains(c.categoryname, 'Apple')}">🍏</c:when>
                    <c:when test="${fn:contains(c.categoryname, 'Samsung')}">📱</c:when>
                    <c:when test="${fn:contains(c.categoryname, 'Xiaomi')}">⚡</c:when>
                    <c:when test="${fn:contains(c.categoryname, 'OPPO')}">📸</c:when>
                    <c:when test="${fn:contains(c.categoryname, 'Vivo')}">🌟</c:when>
                    <c:otherwise>🏷️</c:otherwise>
                </c:choose>
                <span>${c.categoryname}</span>
            </a>
        </c:forEach>
    </div>

    <!-- Thông báo kết quả tìm kiếm nếu có -->
    <c:if test="${not empty keyword}">
        <div class="search-alert">
            <div>
                <i class="bi bi-search me-1"></i> Kết quả tìm kiếm cho từ khóa: <strong>"${keyword}"</strong> (${totalCount} sản phẩm tìm thấy)
            </div>
            <a href="${pageContext.request.contextPath}/product">Xóa bộ lọc</a>
        </div>
    </c:if>

    <!-- Lưới sản phẩm VIP -->
    <div class="product-grid">
        <c:forEach items="${listProduct}" var="p">
            <a href="${pageContext.request.contextPath}/product/detail?id=${p.productId}" class="product-card">
                <span class="card-badge">Chính Hãng</span>

                <div class="img-wrap">
                    <c:choose>
                        <c:when test="${p.images != null && fn:startsWith(p.images, 'http')}">
                            <img src="${p.images}" alt="${p.productName}" loading="lazy">
                        </c:when>
                        <c:otherwise>
                            <img src="<c:url value='/image?fname=${p.images}'/>" alt="${p.productName}" loading="lazy">
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="card-body">
                    <div class="card-category">${p.category.categoryname}</div>
                    <h2 class="card-title">${p.productName}</h2>
                    <c:if test="${not empty p.description}">
                        <div class="card-desc">${p.description}</div>
                    </c:if>

                    <div class="card-rating">
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-half"></i>
                        <span>4.9</span>
                        <span class="count">(100+ đánh giá)</span>
                    </div>

                    <div class="price-row">
                        <div class="card-price">
                            <fmt:formatNumber value="${p.price}" pattern="#,###"/> đ
                        </div>
                        <div class="card-btn" title="Xem chi tiết">
                            <i class="bi bi-arrow-right"></i>
                        </div>
                    </div>
                </div>
            </a>
        </c:forEach>

        <c:if test="${empty listProduct}">
            <div style="grid-column: 1 / -1; text-align: center; padding: 80px 20px; background: #fff; border-radius: 18px; border: 1px dashed #cbd5e1;">
                <i class="bi bi-inbox fs-1 text-muted d-block mb-3"></i>
                <h3 style="font-size: 18px; font-weight: 700; color: #0f172a; margin-bottom: 6px;">Không tìm thấy sản phẩm phù hợp</h3>
                <p style="color: #64748b; font-size: 14px; margin-bottom: 20px;">Vui lòng thử tìm kiếm bằng từ khóa khác hoặc chọn hãng khác.</p>
                <a href="${pageContext.request.contextPath}/product" class="filter-pill active" style="display: inline-flex;">Xem tất cả sản phẩm</a>
            </div>
        </c:if>
    </div>

    <!-- Phân trang thông minh -->
    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:choose>
                <c:when test="${currentPage > 0}">
                    <a href="${pageContext.request.contextPath}/product?page=${currentPage - 1}${not empty selectedCatId ? '&categoryId='.concat(selectedCatId) : ''}${not empty keyword ? '&keyword='.concat(keyword) : ''}">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <span class="disabled"><i class="bi bi-chevron-left"></i></span>
                </c:otherwise>
            </c:choose>

            <c:forEach begin="0" end="${totalPages - 1}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span class="active">${i + 1}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/product?page=${i}${not empty selectedCatId ? '&categoryId='.concat(selectedCatId) : ''}${not empty keyword ? '&keyword='.concat(keyword) : ''}">
                            ${i + 1}
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:choose>
                <c:when test="${currentPage < totalPages - 1}">
                    <a href="${pageContext.request.contextPath}/product?page=${currentPage + 1}${not empty selectedCatId ? '&categoryId='.concat(selectedCatId) : ''}${not empty keyword ? '&keyword='.concat(keyword) : ''}">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <span class="disabled"><i class="bi bi-chevron-right"></i></span>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>

</div>

</body>
</html>
