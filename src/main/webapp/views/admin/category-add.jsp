<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Thêm danh mục</title></head>
<body>
<div class="row justify-content-center">
  <div class="col-lg-7">
    <div class="card shadow-sm"><div class="card-body p-4">
      <h3 class="mb-3">Thêm danh mục</h3>

      <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}"/></div></c:if>

      <form action="<c:url value='/admin/category/insert'/>" method="post" enctype="multipart/form-data"
            class="needs-validation" novalidate>
        <div class="mb-3">
          <label for="categoryname" class="form-label">Tên danh mục</label>
          <input type="text" class="form-control" id="categoryname" name="categoryname" required maxlength="255"
                 value="<c:out value='${param.categoryname}'/>">
          <div class="invalid-feedback">Tên danh mục không được để trống (tối đa 255 ký tự).</div>
        </div>
        <div class="mb-3">
          <label for="images" class="form-label">Link ảnh</label>
          <input type="url" class="form-control" id="images" name="images" maxlength="500"
                 value="<c:out value='${param.images}'/>">
          <div class="invalid-feedback">Link ảnh phải bắt đầu bằng http:// hoặc https://.</div>
        </div>
        <div class="mb-3">
          <label for="images1" class="form-label">Hoặc tải ảnh lên</label>
          <input type="file" class="form-control" id="images1" name="images1" accept="image/*">
        </div>
        <div class="mb-3">
          <label class="form-label d-block">Trạng thái</label>
          <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" id="ston" name="status" value="1" checked>
            <label class="form-check-label" for="ston">Hoạt động</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" id="stoff" name="status" value="0">
            <label class="form-check-label" for="stoff">Khóa</label>
          </div>
        </div>
        <button type="submit" class="btn btn-primary">Thêm</button>
        <a href="<c:url value='/admin/categories'/>" class="btn btn-secondary">Hủy</a>
      </form>
    </div></div>
  </div>
</div>
</body>
</html>