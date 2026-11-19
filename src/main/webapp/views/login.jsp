<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Đăng nhập</title></head>
<body>
<div class="row justify-content-center">
  <div class="col-md-5">
    <div class="card shadow-sm"><div class="card-body p-4">
      <h3 class="text-center mb-3">Đăng nhập</h3>

      <c:if test="${not empty alert}"><div class="alert alert-danger"><c:out value="${alert}"/></div></c:if>
      <c:if test="${not empty verifyEmail}">
        <div class="alert alert-warning">
          <a href="<c:url value='/verify'><c:param name='email' value='${verifyEmail}'/></c:url>">Nhập mã OTP để kích hoạt</a>
        </div>
      </c:if>
      <c:if test="${param.activated == 'true'}"><div class="alert alert-success">Kích hoạt thành công, mời bạn đăng nhập</div></c:if>
      <c:if test="${param.reset == 'true'}"><div class="alert alert-success">Đổi mật khẩu thành công, mời bạn đăng nhập</div></c:if>

      <form action="<c:url value='/login'/>" method="post" class="needs-validation" novalidate>
        <div class="mb-3">
          <label for="username" class="form-label">Tài khoản</label>
          <input type="text" class="form-control" id="username" name="username" required
                 value="<c:out value='${param.username}'/>">
          <div class="invalid-feedback">Vui lòng nhập tài khoản.</div>
        </div>
        <div class="mb-3">
          <label for="password" class="form-label">Mật khẩu</label>
          <input type="password" class="form-control" id="password" name="password" required>
          <div class="invalid-feedback">Vui lòng nhập mật khẩu.</div>
        </div>
        <div class="form-check mb-3">
          <input class="form-check-input" type="checkbox" name="remember" id="remember">
          <label class="form-check-label" for="remember">Nhớ tôi</label>
        </div>
        <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
      </form>
      <div class="d-flex justify-content-between mt-3">
        <a href="<c:url value='/forgot-password'/>">Quên mật khẩu?</a>
        <a href="<c:url value='/register'/>">Đăng ký</a>
      </div>
    </div></div>
  </div>
</div>
</body>
</html>