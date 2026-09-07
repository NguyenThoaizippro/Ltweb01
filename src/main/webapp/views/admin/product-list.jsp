<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Sản phẩm - BT01 Admin</title>
    <style>
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .page-header h1 {
            font-size: 26px;
            font-weight: 800;
            color: #0f172a;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 4px;
        }
        .page-header p {
            color: #64748b;
            font-size: 14px;
            margin: 0;
        }
        .btn-add-primary {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: #ffffff;
            font-weight: 700;
            font-size: 14px;
            padding: 10px 20px;
            border-radius: 10px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
            transition: all 0.2s;
        }
        .btn-add-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(37, 99, 235, 0.35);
        }

        /* Bảng dữ liệu SaaS */
        .table-card {
            background: #ffffff;
            border-radius: 18px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            box-shadow: 0 4px 20px -2px rgba(15, 23, 42, 0.04);
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 14px;
        }
        .data-table thead {
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
        }
        .data-table th {
            padding: 14px 20px;
            font-weight: 700;
            color: #475569;
            font-size: 12.5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .data-table td {
            padding: 16px 20px;
            border-bottom: 1px solid #f1f5f9;
            color: #1e293b;
            vertical-align: middle;
        }
        .data-table tr:hover td {
            background: #f8fafc;
        }

        .prod-thumb {
            width: 54px;
            height: 54px;
            border-radius: 10px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            padding: 4px;
        }
        .prod-thumb img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }

        .prod-title {
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 2px;
        }
        .prod-id {
            font-size: 12px;
            color: #94a3b8;
        }

        .badge-brand {
            background: #eff6ff;
            color: #2563eb;
            font-weight: 700;
            font-size: 12px;
            padding: 4px 10px;
            border-radius: 6px;
            display: inline-block;
        }

        .price-text {
            font-weight: 800;
            color: #ef4444;
            font-size: 15px;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 9999px;
        }
        .status-pill.active {
            background: #dcfce7;
            color: #15803d;
        }
        .status-pill.locked {
            background: #fee2e2;
            color: #b91c1c;
        }

        .btn-action {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-action.edit {
            background: #eff6ff;
            color: #2563eb;
            border: 1px solid #dbeafe;
        }
        .btn-action.edit:hover {
            background: #dbeafe;
        }
        .btn-action.delete {
            background: #fef2f2;
            color: #ef4444;
            border: 1px solid #fee2e2;
            margin-left: 6px;
        }
        .btn-action.delete:hover {
            background: #fee2e2;
        }
    </style>
</head>
<body>

    <div class="page-header">
        <div>
            <h1>
                <i class="bi bi-phone text-primary"></i> Quản Lý Danh Sách Sản Phẩm
            </h1>
            <p>Toàn bộ 50 sản phẩm điện thoại thông minh chính hãng trong hệ thống</p>
        </div>
        <div>
            <a href="<c:url value='/admin/product/add'/>" class="btn-add-primary">
                <i class="bi bi-plus-lg"></i> Thêm Sản Phẩm Mới
            </a>
        </div>
    </div>

    <div class="table-card">
        <table class="data-table">
            <thead>
                <tr>
                    <th style="width: 50px;">STT</th>
                    <th style="width: 80px;">Hình ảnh</th>
                    <th>Tên Sản Phẩm</th>
                    <th>Thương Hiệu</th>
                    <th>Giá Bán</th>
                    <th>Trạng Thái</th>
                    <th style="width: 170px; text-align: right;">Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${listProduct}" var="prod" varStatus="stt">
                    <tr>
                        <td style="color: #64748b; font-weight: 600;">${stt.index + 1}</td>
                        <td>
                            <div class="prod-thumb">
                                <c:choose>
                                    <c:when test="${prod.images != null && fn:startsWith(prod.images, 'http')}">
                                        <img src="${prod.images}" alt="${prod.productName}" loading="lazy">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="<c:url value='/image?fname=${prod.images}'/>" alt="${prod.productName}" loading="lazy">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                        <td>
                            <div class="prod-title">${prod.productName}</div>
                            <div class="prod-id">Mã sản phẩm: #${prod.productId}</div>
                        </td>
                        <td>
                            <span class="badge-brand">${prod.category.categoryname}</span>
                        </td>
                        <td>
                            <span class="price-text"><fmt:formatNumber value="${prod.price}" pattern="#,###"/> đ</span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${prod.status == 1}">
                                    <span class="status-pill active">
                                        <i class="bi bi-check-circle-fill"></i> Đang bán
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-pill locked">
                                        <i class="bi bi-lock-fill"></i> Tạm khóa
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="text-align: right;">
                            <a href="<c:url value='/admin/product/edit?id=${prod.productId}'/>" class="btn-action edit" title="Chỉnh sửa">
                                <i class="bi bi-pencil-square"></i> Sửa
                            </a>
                            <a href="<c:url value='/admin/product/delete?id=${prod.productId}'/>" class="btn-action delete" onclick="return confirm('Bạn có chắc muốn xóa sản phẩm ${prod.productName}?')" title="Xóa">
                                <i class="bi bi-trash"></i> Xóa
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</body>
</html>
