<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Hồ sơ cá nhân</title></head>
<body>
<div class="row justify-content-center">
  <div class="col-lg-7">
    <div class="card shadow-sm"><div class="card-body p-4">
      <h3 class="mb-4">Hồ sơ cá nhân</h3>

      <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}"/></div></c:if>
      <c:if test="${param.success == 'true'}"><div class="alert alert-success">Cập nhật hồ sơ thành công</div></c:if>
      <c:if test="${param.emailChanged == 'true'}"><div class="alert alert-success">Đổi email thành công</div></c:if>
      <c:if test="${not empty profile.pendingEmail}">
        <div class="alert alert-warning">
          Email mới <b><c:out value="${profile.pendingEmail}"/></b> đang chờ xác nhận.
          <a href="<c:url value='/profile/verify'/>">Nhập mã OTP</a>
        </div>
      </c:if>

      <div class="text-center mb-4">
        <c:choose>
          <c:when test="${fn:startsWith(profile.avatar, 'http')}">
            <img id="preview" src="<c:out value='${profile.avatar}'/>" class="rounded-circle border"
                 width="120" height="120" style="object-fit:cover" alt="Avatar">
          </c:when>
          <c:otherwise>
            <img id="preview" src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='120' height='120'><rect width='120' height='120' fill='%23adb5bd'/></svg>"
                 class="rounded-circle border" width="120" height="120" alt="Avatar">
          </c:otherwise>
        </c:choose>
      </div>

      <form action="<c:url value='/profile'/>" method="post" enctype="multipart/form-data"
            class="needs-validation" novalidate>
        <div class="mb-3">
          <label for="fullname" class="form-label">Họ tên</label>
          <input type="text" class="form-control" id="fullname" name="fullname" required minlength="2" maxlength="100"
                 value="<c:out value='${not empty param.fullname ? param.fullname : profile.fullname}'/>">
          <div class="invalid-feedback">Họ tên từ 2 đến 100 ký tự.</div>
        </div>
        <div class="mb-3">
          <label for="phone" class="form-label">Số điện thoại</label>
          <input type="text" class="form-control" id="phone" name="phone" required pattern="0[0-9]{9}"
                 value="<c:out value='${not empty param.phone ? param.phone : profile.phone}'/>">
          <div class="invalid-feedback">Số điện thoại gồm 10 chữ số, bắt đầu bằng 0.</div>
        </div>
        <div class="mb-3">
          <label for="email" class="form-label">Email</label>
          <input type="email" class="form-control" id="email" name="email" required maxlength="255"
                 value="<c:out value='${not empty param.email ? param.email : profile.email}'/>">
          <div class="form-text">Nếu đổi email, mã OTP sẽ được gửi đến email mới để xác nhận.</div>
          <div class="invalid-feedback">Vui lòng nhập email hợp lệ.</div>
        </div>
        <div class="mb-3">
          <label for="avatarFile" class="form-label">Ảnh đại diện (JPG/PNG/GIF/WEBP, tối đa 5 MB)</label>
          <input type="file" class="form-control" id="avatarFile" name="avatarFile"
                 accept="image/jpeg,image/png,image/gif,image/webp">
          <div class="invalid-feedback">Ảnh không được vượt quá 5 MB.</div>
        </div>
        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
      </form>
    </div></div>
  </div>
</div>
<script>
document.getElementById('avatarFile').addEventListener('change', function () {
  var f = this.files[0];
  this.setCustomValidity(f && f.size > 5 * 1024 * 1024 ? 'Quá lớn' : '');
  if (f && f.type.startsWith('image/')) {
    document.getElementById('preview').src = URL.createObjectURL(f);
  }
});
</script>
</body>
</html>