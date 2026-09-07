<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Danh mục - BT01 Admin</title>
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

        .cat-thumb {
            width: 70px;
            height: 50px;
            border-radius: 10px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            padding: 2px;
        }
        .cat-thumb img {
            max-width: 100%;
            max-height: 100%;
            object-fit: cover;
        }

        .cat-name {
            font-weight: 700;
            font-size: 15px;
            color: #0f172a;
        }
        .cat-id {
            font-size: 12px;
            color: #94a3b8;
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
                <i class="bi bi-folder2-open text-primary"></i> Quản Lý Danh Mục Thương Hiệu
            </h1>
            <p>Danh sách 5 thương hiệu điện thoại hàng đầu trong hệ thống</p>
        </div>
        <div>
            <a href="<c:url value='/admin/category/add'/>" class="btn-add-primary">
                <i class="bi bi-plus-lg"></i> Thêm Danh Mục Mới
            </a>
        </div>
    </div>

    <div class="table-card">
        <table class="data-table">
            <thead>
                <tr>
                    <th style="width: 60px;">STT</th>
                    <th style="width: 90px;">Hình ảnh</th>
                    <th>Tên Danh Mục</th>
                    <th>Trạng Thái</th>
                    <th style="width: 170px; text-align: right;">Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${listcate}" var="cate" varStatus="stt">
                    <c:choose>
                        <c:when test="${cate.images != null && fn:startsWith(cate.images, 'http')}">
                            <c:url value="${cate.images}" var="imgUrl"/>
                        </c:when>
                        <c:otherwise>
                            <c:url value="/image?fname=${cate.images}" var="imgUrl"/>
                        </c:otherwise>
                    </c:choose>
                    <tr>
                        <td style="color: #64748b; font-weight: 600;">${stt.index + 1}</td>
                        <td>
                            <div class="cat-thumb">
                                <img src="${imgUrl}" alt="${cate.categoryname}" loading="lazy">
                            </div>
                        </td>
                        <td>
                            <div class="cat-name">${cate.categoryname}</div>
                            <div class="cat-id">Mã danh mục: #${cate.categoryid}</div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${cate.status == 1}">
                                    <span class="status-pill active">
                                        <i class="bi bi-check-circle-fill"></i> Hoạt động
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-pill locked">
                                        <i class="bi bi-lock-fill"></i> Khóa
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="text-align: right;">
                            <a href="<c:url value='/admin/category/edit?id=${cate.categoryid}'/>" class="btn-action edit" title="Chỉnh sửa">
                                <i class="bi bi-pencil-square"></i> Sửa
                            </a>
                            <a href="<c:url value='/admin/category/delete?id=${cate.categoryid}'/>" class="btn-action delete" onclick="return confirm('Bạn có chắc muốn xóa danh mục ${cate.categoryname}?')" title="Xóa">
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
