<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} - toi di ban hang</title>
    <style>
        .container {
            max-width: 1200px;
            margin: 28px auto 60px auto;
            padding: 0 24px;
        }

        /* Breadcrumb */
        .breadcrumb-nav {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13.5px;
            color: #64748b;
            margin-bottom: 24px;
        }
        .breadcrumb-nav a {
            color: #64748b;
            text-decoration: none;
            transition: color 0.2s;
        }
        .breadcrumb-nav a:hover { color: #2563eb; }
        .breadcrumb-nav span.current {
            color: #0f172a;
            font-weight: 600;
        }

        /* Main 2-column Detail Card */
        .detail-wrapper {
            background: #ffffff;
            border-radius: 24px;
            border: 1px solid rgba(226, 232, 240, 0.9);
            box-shadow: 0 8px 30px -4px rgba(15, 23, 42, 0.05);
            display: grid;
            grid-template-columns: 1.1fr 1.3fr;
            gap: 48px;
            padding: 44px;
            margin-bottom: 40px;
        }
        @media (max-width: 900px) {
            .detail-wrapper {
                grid-template-columns: 1fr;
                padding: 24px;
                gap: 32px;
            }
        }

        /* Image Column */
        .image-col {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .main-img-box {
            width: 100%;
            height: 420px;
            background: #f8fafc;
            border-radius: 18px;
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            overflow: hidden;
        }
        .main-img-box img {
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
            transition: transform 0.3s ease;
        }
        .main-img-box:hover img {
            transform: scale(1.05);
        }

        .guarantee-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 16px 20px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            font-size: 13px;
            color: #334155;
        }
        .guarantee-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .guarantee-item i {
            color: #2563eb;
            font-size: 16px;
        }

        /* Info Column */
        .info-col {
            display: flex;
            flex-direction: column;
        }
        .brand-pill-sm {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #eff6ff;
            color: #2563eb;
            font-size: 12.5px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 9999px;
            width: fit-content;
            margin-bottom: 12px;
        }
        .product-name {
            font-size: 30px;
            font-weight: 800;
            color: #0f172a;
            line-height: 1.25;
            margin-bottom: 12px;
            letter-spacing: -0.5px;
        }

        .rating-bar {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13.5px;
            color: #f59e0b;
            margin-bottom: 20px;
            padding-bottom: 16px;
            border-bottom: 1px solid #f1f5f9;
        }
        .rating-bar span.text-muted {
            color: #64748b;
            font-weight: 500;
        }

        /* Price Box */
        .price-card {
            background: #f8fafc;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            padding: 20px 24px;
            margin-bottom: 24px;
            display: flex;
            align-items: baseline;
            gap: 14px;
            flex-wrap: wrap;
        }
        .main-price {
            font-size: 32px;
            font-weight: 800;
            color: #ef4444;
            letter-spacing: -1px;
        }
        .price-badge {
            background: #fee2e2;
            color: #dc2626;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 6px;
        }
        .installment-badge {
            background: #f0fdf4;
            color: #166534;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 6px;
            border: 1px solid #bbf7d0;
        }

        /* Description Box */
        .desc-box {
            margin-bottom: 32px;
        }
        .desc-title {
            font-size: 15px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .desc-content {
            font-size: 14.5px;
            line-height: 1.7;
            color: #475569;
            white-space: pre-line;
        }

        /* Action Buttons */
        .actions-group {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-top: auto;
        }
        .btn-buy-now {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: #ffffff;
            font-size: 16px;
            font-weight: 700;
            padding: 14px 28px;
            border-radius: 14px;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.25s ease;
            box-shadow: 0 4px 16px rgba(37, 99, 235, 0.35);
        }
        .btn-buy-now:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(37, 99, 235, 0.45);
        }
        .btn-add-cart {
            background: #ffffff;
            color: #2563eb;
            border: 2px solid #2563eb;
            font-size: 15px;
            font-weight: 700;
            padding: 12px 28px;
            border-radius: 14px;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s;
        }
        .btn-add-cart:hover {
            background: #eff6ff;
        }
        .back-link {
            color: #64748b;
            text-decoration: none;
            font-size: 13.5px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-top: 8px;
            justify-content: center;
        }
        .back-link:hover { color: #2563eb; }
    </style>
</head>
<body>

<div class="container">

    <!-- Breadcrumb -->
    <div class="breadcrumb-nav">
        <a href="${pageContext.request.contextPath}/home"><i class="bi bi-house-door"></i> Trang chủ</a>
        <i class="bi bi-chevron-right text-muted" style="font-size: 11px;"></i>
        <a href="${pageContext.request.contextPath}/product">Sản phẩm</a>
        <i class="bi bi-chevron-right text-muted" style="font-size: 11px;"></i>
        <span class="current">${product.productName}</span>
    </div>

    <!-- 2-Column Detail Card -->
    <div class="detail-wrapper">
        <!-- Cột Ảnh & Cam kết -->
        <div class="image-col">
            <div class="main-img-box">
                <c:choose>
                    <c:when test="${product.images != null && fn:startsWith(product.images, 'http')}">
                        <img src="${product.images}" alt="${product.productName}">
                    </c:when>
                    <c:otherwise>
                        <img src="<c:url value='/image?fname=${product.images}'/>" alt="${product.productName}">
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Cam kết bảo hành chính hãng -->
            <div class="guarantee-box">
                <div class="guarantee-item">
                    <i class="bi bi-patch-check-fill text-primary"></i>
                    <span>Sản phẩm chính hãng VN/A, bảo hành 12 tháng tại các TTBH ủy quyền.</span>
                </div>
                <div class="guarantee-item">
                    <i class="bi bi-arrow-repeat text-success"></i>
                    <span>Lỗi 1 đổi 1 trong vòng 30 ngày nếu có lỗi phần cứng từ NSX.</span>
                </div>
                <div class="guarantee-item">
                    <i class="bi bi-box2-fill text-warning"></i>
                    <span>Bộ sản phẩm bao gồm: Máy nguyên seal, Cáp sạc, Sách hướng dẫn, Cây lấy sim.</span>
                </div>
            </div>
        </div>

        <!-- Cột Thông tin chi tiết & Mua hàng -->
        <div class="info-col">
            <div class="brand-pill-sm">
                <i class="bi bi-tag-fill"></i> ${product.category.categoryname}
            </div>

            <h1 class="product-name">${product.productName}</h1>

            <div class="rating-bar">
                <i class="bi bi-star-fill"></i>
                <i class="bi bi-star-fill"></i>
                <i class="bi bi-star-fill"></i>
                <i class="bi bi-star-fill"></i>
                <i class="bi bi-star-half"></i>
                <strong style="color: #0f172a; margin-left: 2px;">4.9</strong>
                <span class="text-muted">(186 đánh giá từ khách hàng đã mua)</span>
            </div>

            <!-- Khung giá tiền -->
            <div class="price-card">
                <div class="main-price">
                    <fmt:formatNumber value="${product.price}" pattern="#,###"/> đ
                </div>
                <span class="price-badge">Giảm sốc 15%</span>
                <span class="installment-badge">Trả góp 0%</span>
            </div>

            <!-- Mô tả sản phẩm -->
            <div class="desc-box">
                <div class="desc-title">
                    <i class="bi bi-info-circle-fill text-primary"></i> Đặc điểm nổi bật & Thông số kỹ thuật:
                </div>
                <div class="desc-content">
                    <c:choose>
                        <c:when test="${not empty product.description}">
                            ${product.description}
                        </c:when>
                        <c:otherwise>
                            Sản phẩm điện thoại thông minh cao cấp chính hãng, thiết kế hiện đại, camera sắc nét, pin dung lượng cao và hiệu năng ổn định.
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Nút mua hàng -->
            <div class="actions-group">
                <a href="${pageContext.request.contextPath}/home" class="btn-buy-now">
                    <i class="bi bi-lightning-charge-fill"></i> MUA NGAY - GIAO SIÊU TỐC 2H
                </a>
                <a href="${pageContext.request.contextPath}/product" class="btn-add-cart">
                    <i class="bi bi-cart-plus-fill"></i> TIẾP TỤC CHỌN SẢN PHẨM KHÁC
                </a>
                <a href="${pageContext.request.contextPath}/product" class="back-link">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách sản phẩm
                </a>
            </div>
        </div>
    </div>

</div>

</body>
</html>
