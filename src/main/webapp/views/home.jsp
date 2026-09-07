<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - toi di ban hang</title>
    <style>
        /* Hero Banner Phong Cách Apple / Flagship */
        .hero-banner {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #1e3a8a 100%);
            color: #ffffff;
            border-radius: 24px;
            padding: 56px 48px;
            margin: 28px auto 40px auto;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 40px -15px rgba(15, 23, 42, 0.3);
        }
        .hero-banner::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(59, 130, 246, 0.25) 0%, transparent 70%);
            pointer-events: none;
        }
        .hero-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            color: #60a5fa;
            font-size: 12.5px;
            font-weight: 700;
            padding: 5px 14px;
            border-radius: 9999px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 18px;
        }
        .hero-title {
            font-size: 42px;
            font-weight: 800;
            line-height: 1.15;
            margin-bottom: 16px;
            letter-spacing: -1px;
            max-width: 760px;
        }
        .hero-title span {
            background: linear-gradient(90deg, #60a5fa 0%, #a78bfa 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .hero-subtitle {
            font-size: 16px;
            color: #cbd5e1;
            line-height: 1.6;
            margin-bottom: 30px;
            max-width: 620px;
        }
        .hero-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
        }
        .btn-hero-primary {
            background: #2563eb;
            color: #ffffff;
            font-weight: 700;
            font-size: 15px;
            padding: 12px 28px;
            border-radius: 9999px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.25s ease;
            box-shadow: 0 4px 16px rgba(37, 99, 235, 0.4);
        }
        .btn-hero-primary:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(37, 99, 235, 0.5);
        }
        .btn-hero-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            font-weight: 600;
            font-size: 15px;
            padding: 12px 24px;
            border-radius: 9999px;
            text-decoration: none;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.2s;
        }
        .btn-hero-secondary:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        /* Container chuẩn */
        .container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 24px;
        }

        /* Brand Quick Filter Bar (Thanh chọn hãng VIP) */
        .brand-section {
            margin-bottom: 40px;
        }
        .brand-section-header {
            font-size: 14px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .brand-pills-wrap {
            display: flex;
            align-items: center;
            gap: 12px;
            overflow-x: auto;
            padding-bottom: 8px;
        }
        .brand-pill {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 20px;
            background: #ffffff;
            border: 1.5px solid #e2e8f0;
            border-radius: 9999px;
            color: #1e293b;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            white-space: nowrap;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
            transition: all 0.2s ease;
        }
        .brand-pill:hover {
            border-color: #2563eb;
            color: #2563eb;
            background: #eff6ff;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.12);
        }
        .brand-pill img {
            width: 20px;
            height: 20px;
            object-fit: cover;
            border-radius: 50%;
        }

        /* Section Tiêu đề */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 24px;
        }
        .section-title {
            font-size: 26px;
            font-weight: 800;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: -0.5px;
        }
        .view-all-link {
            color: #2563eb;
            text-decoration: none;
            font-weight: 700;
            font-size: 14.5px;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: gap 0.2s;
        }
        .view-all-link:hover {
            gap: 10px;
            color: #1d4ed8;
        }

        /* Lưới sản phẩm VIP */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 24px;
            margin-bottom: 50px;
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

        /* Badge góc */
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

        /* Khung ảnh sản phẩm */
        .img-wrap {
            width: 100%;
            height: 220px;
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

        /* Nội dung thẻ */
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
        
        /* Đánh giá sao */
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

        /* Giá tiền & Nút bấm */
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
    </style>
</head>
<body>

<div class="container">

    <!-- 1. Hero Flagship Banner -->
    <div class="hero-banner">
        <div class="hero-tag">
            <i class="bi bi-stars"></i> Siêu Phẩm Công Nghệ 2026
        </div>
        <h1 class="hero-title">
            Khám Phá Sức Mạnh <span>Titanium & Trí Tuệ Nhân Tạo AI</span>
        </h1>
        <p class="hero-subtitle">
            Trải nghiệm các dòng Flagship hàng đầu: iPhone 16 Pro Max, Samsung Galaxy S24 Ultra, Xiaomi 14 Leica với ưu đãi đặc quyền bảo hành 12 tháng chính hãng.
        </p>
        <div class="hero-actions">
            <a href="#featured-section" class="btn-hero-primary">
                <i class="bi bi-bag-check-fill"></i> Khám phá ngay
            </a>
            <a href="${pageContext.request.contextPath}/product" class="btn-hero-secondary">
                Xem toàn bộ 50 sản phẩm →
            </a>
        </div>
    </div>

    <!-- 2. Brand Quick Filter Bar (Bộ lọc theo hãng) -->
    <div class="brand-section">
        <div class="brand-section-header">
            <i class="bi bi-grid-fill text-primary"></i> Chọn theo thương hiệu yêu thích
        </div>
        <div class="brand-pills-wrap">
            <a href="${pageContext.request.contextPath}/product" class="brand-pill">
                <i class="bi bi-collection text-primary"></i> Tất cả sản phẩm
            </a>
            <c:forEach items="${categories}" var="c">
                <a href="${pageContext.request.contextPath}/product?categoryId=${c.categoryid}" class="brand-pill">
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
    </div>

    <!-- 3. Danh sách 6 Sản phẩm Nổi bật (Hiển thị 6 sản phẩm) -->
    <div id="featured-section">
        <div class="section-header">
            <div>
                <h2 class="section-title">
                    <i class="bi bi-fire text-danger"></i> Sản Phẩm Mới & Nổi Bật Nhất
                </h2>
            </div>
            <a href="${pageContext.request.contextPath}/product" class="view-all-link">
                Xem tất cả 50 sản phẩm <i class="bi bi-arrow-right"></i>
            </a>
        </div>

        <div class="product-grid">
            <c:forEach items="${not empty top6 ? top6 : top10}" var="p">
                <a href="${pageContext.request.contextPath}/product/detail?id=${p.productId}" class="product-card">
                    <!-- Badge -->
                    <span class="card-badge">Chính Hãng</span>

                    <!-- Ảnh sản phẩm với hover zoom -->
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

                    <!-- Nội dung thẻ -->
                    <div class="card-body">
                        <div class="card-category">${p.category.categoryname}</div>
                        <h3 class="card-title">${p.productName}</h3>

                        <!-- Rating sao VIP -->
                        <div class="card-rating">
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-half"></i>
                            <span>4.9</span>
                            <span class="count">(120+ đã bán)</span>
                        </div>

                        <!-- Hàng giá tiền & nút -->
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

            <c:if test="${empty top10}">
                <div style="grid-column: 1 / -1; text-align: center; padding: 60px 20px; background: #fff; border-radius: 18px;">
                    <i class="bi bi-box2 fs-1 text-muted d-block mb-2"></i>
                    <p style="color: #64748b; margin: 0;">Hiện chưa có sản phẩm nào được hiển thị.</p>
                </div>
            </c:if>
        </div>
    </div>

</div>

</body>
</html>
