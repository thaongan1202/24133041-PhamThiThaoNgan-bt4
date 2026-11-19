<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Quên mật khẩu</title></head>
<body>
<div class="row justify-content-center">
  <div class="col-md-5">
    <div class="card shadow-sm"><div class="card-body p-4">
      <h3 class="text-center mb-3">Quên mật khẩu</h3>

      <c:if test="${not empty alert}"><div class="alert alert-danger"><c:out value="${alert}"/></div></c:if>

      <form action="<c:url value='/forgot-password'/>" method="post" class="needs-validation" novalidate>
        <div class="mb-3">
          <label for="email" class="form-label">Email đã đăng ký</label>
          <input type="email" class="form-control" id="email" name="email" required maxlength="255"
                 value="<c:out value='${param.email}'/>">
          <div class="invalid-feedback">Vui lòng nhập email hợp lệ.</div>
        </div>
        <button type="submit" class="btn btn-primary w-100">Gửi mã xác nhận</button>
      </form>
      <p class="text-center mt-3 mb-0"><a href="<c:url value='/login'/>">Quay lại đăng nhập</a></p>
    </div></div>
  </div>
</div>
</body>
</html>