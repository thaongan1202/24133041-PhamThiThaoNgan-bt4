<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><c:choose><c:when test="${editing}">Sửa video</c:when><c:otherwise>Thêm video</c:otherwise></c:choose></title>
</head>
<body>
<div class="row justify-content-center">
  <div class="col-lg-8">
    <div class="card shadow-sm"><div class="card-body p-4">
      <h3 class="mb-3"><c:choose><c:when test="${editing}">Sửa video</c:when><c:otherwise>Thêm video</c:otherwise></c:choose></h3>

      <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}"/></div></c:if>
      <c:if test="${empty categories}">
        <div class="alert alert-warning">Hãy tạo ít nhất một danh mục trước khi thêm video.</div>
      </c:if>

      <c:choose>
        <c:when test="${editing}"><c:url var="formAction" value="/admin/video/update"/></c:when>
        <c:otherwise><c:url var="formAction" value="/admin/video/insert"/></c:otherwise>
      </c:choose>
      <c:set var="posterLink" value=""/>
      <c:if test="${fn:startsWith(video.poster, 'http://') or fn:startsWith(video.poster, 'https://')}">
        <c:set var="posterLink" value="${video.poster}"/>
      </c:if>

      <form method="post" action="${formAction}" enctype="multipart/form-data" class="needs-validation" novalidate>
        <div class="mb-3">
          <label for="videoId" class="form-label">ID hoặc URL YouTube</label>
          <input id="videoId" name="videoId" type="text" class="form-control" required maxlength="100"
                 value="<c:out value='${video.videoId}'/>" placeholder="VD: M7lc1UVf-VE hoặc https://www.youtube.com/watch?v=..."
                 <c:if test="${editing}">readonly</c:if>>
          <div class="invalid-feedback">Vui lòng nhập ID hoặc URL YouTube.</div>
        </div>

        <div class="mb-3">
          <label for="title" class="form-label">Tiêu đề</label>
          <input id="title" name="title" type="text" class="form-control" required maxlength="500"
                 value="<c:out value='${video.title}'/>">
          <div class="invalid-feedback">Tiêu đề không được để trống (tối đa 500 ký tự).</div>
        </div>

        <div class="mb-3">
          <label for="description" class="form-label">Mô tả (tối đa 500 ký tự)</label>
          <textarea id="description" name="description" rows="4" maxlength="500" class="form-control"><c:out value="${video.description}"/></textarea>
          <div class="invalid-feedback">Mô tả tối đa 500 ký tự.</div>
        </div>

        <div class="mb-3">
          <label for="categoryId" class="form-label">Danh mục</label>
          <select id="categoryId" name="categoryId" class="form-select" required>
            <option value="">-- Chọn danh mục --</option>
            <c:forEach items="${categories}" var="category">
              <option value="${category.categoryid}" <c:if test="${video.category.categoryid == category.categoryid}">selected</c:if>><c:out value="${category.categoryname}"/></option>
            </c:forEach>
          </select>
          <div class="invalid-feedback">Vui lòng chọn danh mục.</div>
        </div>

        <div class="mb-3">
          <label for="posterUrl" class="form-label">Link poster (có thể bỏ trống nếu tải ảnh lên)</label>
          <input id="posterUrl" name="posterUrl" type="url" class="form-control" maxlength="500"
                 value="<c:out value='${posterLink}'/>">
          <div class="invalid-feedback">Link poster phải bắt đầu bằng http:// hoặc https://.</div>
        </div>

        <div class="mb-3">
          <label for="posterFile" class="form-label">Hoặc tải poster lên (JPG/PNG/GIF/WEBP, tối đa 5 MB)</label>
          <input id="posterFile" name="posterFile" type="file" class="form-control"
                 accept="image/jpeg,image/png,image/gif,image/webp">
          <div class="invalid-feedback">Ảnh không được vượt quá 5 MB.</div>
        </div>

        <c:if test="${not empty video.poster}">
          <div class="mb-3">
            <div class="form-label">Poster hiện tại</div>
            <c:choose>
              <c:when test="${fn:startsWith(video.poster, 'http://') or fn:startsWith(video.poster, 'https://')}">
                <img src="<c:out value='${video.poster}'/>" width="240" class="img-thumbnail" alt="Poster hiện tại">
              </c:when>
              <c:otherwise>
                <c:url var="currentPoster" value="/image"><c:param name="fname" value="${video.poster}"/></c:url>
                <img src="${currentPoster}" width="240" class="img-thumbnail" alt="Poster hiện tại">
              </c:otherwise>
            </c:choose>
          </div>
        </c:if>

        <div class="mb-3">
          <label class="form-label d-block">Trạng thái</label>
          <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" id="active1" name="active" value="1" <c:if test="${video.active == 1}">checked</c:if>>
            <label class="form-check-label" for="active1">Đang bật</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" id="active0" name="active" value="0" <c:if test="${video.active == 0}">checked</c:if>>
            <label class="form-check-label" for="active0">Đang ẩn</label>
          </div>
        </div>

        <button type="submit" class="btn btn-primary"><c:choose><c:when test="${editing}">Cập nhật</c:when><c:otherwise>Thêm video</c:otherwise></c:choose></button>
        <a href="<c:url value='/admin/videos'/>" class="btn btn-secondary">Hủy</a>
      </form>
    </div></div>
  </div>
</div>
</body>
</html>