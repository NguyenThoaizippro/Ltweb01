<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Category</title>
</head>
<body>
<%@ include file="/views/topbar.jsp" %>
<h2>Sửa Category</h2>
<form action="<c:url value="/admin/category/update"/>" method="post" enctype="multipart/form-data">
<input type="text" name ="categoryid" value="${cate.categoryid}" hidden="hidden">
<label for="fname">Category name:</label><br>
<input type="text" id="categoryname" name="categoryname" value="${cate.categoryname}"><br>
<label for="lname">Link images:</label><br>
<input type="text" id="images" name="images" value="${cate.images}"><br>

<c:choose>
    <c:when test="${cate.images != null && fn:startsWith(cate.images, 'http')}">
        <c:url value="${cate.images}" var="imgUrl"></c:url>
    </c:when>
    <c:otherwise>
        <c:url value="/image?fname=${cate.images}" var="imgUrl"></c:url>
    </c:otherwise>
</c:choose>

<img height="150" width="200" src="${imgUrl}" /><br>

<label for="lname">Upload images:</label><br>
<input type="file" id="images1" name="images1"><br>

<label for="html">Status</label><br>
<input type="radio" id="ston" name="status" value="1" ${cate.status==1?'checked':'' }>
<label for="css">Hoạt động</label><br>
<input type="radio" id="stoff" name="status" value="0" ${cate.status!=1?'checked':'' }>
<label for="javascript">Khóa</label>

<br><br>
<input type="submit" value="Update">
</form>
</body>
</html>
