<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Đặt lại mật khẩu</title></head>
<body>
<div class="row justify-content-center">
  <div class="col-md-5">
    <div class="card shadow-sm"><div class="card-body p-4">
      <h3 class="text-center mb-3">Đặt lại mật khẩu</h3>
      <p>Mã OTP đã được gửi tới email: <b><c:out value="${email}"/></b></p>

      <c:if test="${not empty alert}"><div class="alert alert-danger"><c:out value="${alert}"/></div></c:if>

      <form action="<c:url value='/reset-password'/>" method="post" class="needs-validation" novalidate>
        <input type="hidden" name="email" value="<c:out value='${email}'/>">

        <div class="mb-3">
          <label for="otp" class="form-label">Mã OTP</label>
          <input type="text" class="form-control" id="otp" name="otp" required
                 pattern="[0-9]{6}" maxlength="6" placeholder="6 chữ số">
          <div class="invalid-feedback">Mã OTP gồm đúng 6 chữ số.</div>
        </div>
        <div class="mb-3">
          <label for="password" class="form-label">Mật khẩu mới</label>
          <input type="password" class="form-control" id="password" name="password" required minlength="6" maxlength="50">
          <div class="invalid-feedback">Mật khẩu từ 6 đến 50 ký tự.</div>
        </div>
        <div class="mb-3">
          <label for="repassword" class="form-label">Nhập lại mật khẩu mới</label>
          <input type="password" class="form-control" id="repassword" name="repassword" required data-match="#password">
          <div class="invalid-feedback">Mật khẩu nhập lại không khớp.</div>
        </div>
        <button type="submit" class="btn btn-primary w-100">Đổi mật khẩu</button>
      </form>
    </div></div>
  </div>
</div>
</body>
</html>