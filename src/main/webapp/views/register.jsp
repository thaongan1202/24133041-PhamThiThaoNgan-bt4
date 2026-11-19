<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Đăng ký</title></head>
<body>
<div class="row justify-content-center">
  <div class="col-md-6">
    <div class="card shadow-sm"><div class="card-body p-4">
      <h3 class="text-center mb-3">Tạo tài khoản mới</h3>
      <c:if test="${not empty alert}"><div class="alert alert-danger"><c:out value="${alert}"/></div></c:if>

      <form action="<c:url value='/register'/>" method="post" class="needs-validation" novalidate>
        <div class="mb-3">
          <label for="username" class="form-label">Tài khoản</label>
          <input type="text" class="form-control" id="username" name="username" required
                 pattern="[A-Za-z0-9_]{4,30}" value="<c:out value='${param.username}'/>">
          <div class="invalid-feedback">4-30 ký tự, chỉ gồm chữ, số và dấu gạch dưới.</div>
        </div>
        <div class="mb-3">
          <label for="fullname" class="form-label">Họ tên</label>
          <input type="text" class="form-control" id="fullname" name="fullname" required
                 minlength="2" maxlength="100" value="<c:out value='${param.fullname}'/>">
          <div class="invalid-feedback">Họ tên từ 2 đến 100 ký tự.</div>
        </div>
        <div class="mb-3">
          <label for="email" class="form-label">Email</label>
          <input type="email" class="form-control" id="email" name="email" required maxlength="255"
                 value="<c:out value='${param.email}'/>">
          <div class="invalid-feedback">Vui lòng nhập email hợp lệ.</div>
        </div>
        <div class="mb-3">
          <label for="phone" class="form-label">Số điện thoại</label>
          <input type="text" class="form-control" id="phone" name="phone" required
                 pattern="0[0-9]{9}" value="<c:out value='${param.phone}'/>">
          <div class="invalid-feedback">Số điện thoại gồm 10 chữ số, bắt đầu bằng 0.</div>
        </div>
        <div class="mb-3">
          <label for="password" class="form-label">Mật khẩu</label>
          <input type="password" class="form-control" id="password" name="password" required minlength="6" maxlength="50">
          <div class="invalid-feedback">Mật khẩu từ 6 đến 50 ký tự.</div>
        </div>
        <div class="mb-3">
          <label for="repassword" class="form-label">Nhập lại mật khẩu</label>
          <input type="password" class="form-control" id="repassword" name="repassword" required data-match="#password">
          <div class="invalid-feedback">Mật khẩu nhập lại không khớp.</div>
        </div>
        <button type="submit" class="btn btn-primary w-100">Tạo tài khoản</button>
      </form>
      <p class="text-center mt-3 mb-0">Đã có tài khoản? <a href="<c:url value='/login'/>">Đăng nhập</a></p>
    </div></div>
  </div>
</div>
</body>
</html>