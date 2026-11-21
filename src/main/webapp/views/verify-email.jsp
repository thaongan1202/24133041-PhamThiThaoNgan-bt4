<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Xác nhận email mới</title></head>
<body>
<div class="row justify-content-center">
  <div class="col-md-5">
    <div class="card shadow-sm"><div class="card-body p-4">
      <h3 class="text-center mb-3">Xác nhận email mới</h3>
      <p>Mã OTP đã được gửi tới: <b><c:out value="${profile.pendingEmail}"/></b></p>

      <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}"/></div></c:if>
      <c:if test="${param.sent == 'false'}"><div class="alert alert-danger">Chưa gửi được email, hãy bấm "Gửi lại mã"</div></c:if>
      <c:if test="${param.resent == 'true'}"><div class="alert alert-success">Đã gửi lại mã mới</div></c:if>

      <form action="<c:url value='/profile/verify'/>" method="post" class="needs-validation" novalidate>
        <div class="mb-3">
          <input type="text" class="form-control" name="otp" placeholder="Nhập mã OTP 6 số"
                 required pattern="[0-9]{6}" maxlength="6">
          <div class="invalid-feedback">Mã OTP gồm 6 chữ số.</div>
        </div>
        <button type="submit" class="btn btn-primary w-100">Xác nhận</button>
      </form>
      <p class="mt-3 mb-0">
        <a href="<c:url value='/profile'><c:param name='x' value='1'/></c:url>">← Về hồ sơ</a> ·
        <a href="<c:url value='/profile/verify'><c:param name='resend' value='true'/></c:url>">Gửi lại mã</a>
      </p>
    </div></div>
  </div>
</div>
</body>
</html>