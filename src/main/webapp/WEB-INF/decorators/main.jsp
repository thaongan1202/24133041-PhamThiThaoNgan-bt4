<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><sitemesh:write property="title"/> - ShoppingJPA</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <sitemesh:write property="head"/>
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container">
    <a class="navbar-brand" href="<c:url value='/home'/>">ShoppingJPA</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="nav">
      <ul class="navbar-nav me-auto">
        <li class="nav-item"><a class="nav-link" href="<c:url value='/home'/>">Trang chủ</a></li>
        <li class="nav-item"><a class="nav-link" href="<c:url value='/video'/>">Video của tôi</a></li>
        <li class="nav-item"><a class="nav-link" href="<c:url value='/admin/videos'/>">Quản lý video</a></li>
        <li class="nav-item"><a class="nav-link" href="<c:url value='/admin/categories'/>">Quản lý danh mục</a></li>
        <li class="nav-item"><a class="nav-link" href="<c:url value='/multiPartServlet'/>">Upload file</a></li>
      </ul>
      <ul class="navbar-nav">
        <c:choose>
          <c:when test="${not empty sessionScope.account}">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" data-bs-toggle="dropdown">
                <c:if test="${fn:startsWith(sessionScope.account.avatar, 'http')}">
                  <img src="<c:out value='${sessionScope.account.avatar}'/>" class="rounded-circle" width="28" height="28" style="object-fit:cover" alt="">
                </c:if>
                <c:out value="${sessionScope.account.fullname}"/>
              </a>
              <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="<c:url value='/profile'/>">Hồ sơ cá nhân</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="<c:url value='/logout'/>">Đăng xuất</a></li>
              </ul>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item"><a class="nav-link" href="<c:url value='/login'/>">Đăng nhập</a></li>
            <li class="nav-item"><a class="nav-link" href="<c:url value='/register'/>">Đăng ký</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<main class="container py-4 flex-grow-1">
  <sitemesh:write property="body"/>
</main>

<footer class="bg-dark text-white-50 text-center py-3">
  &copy; 2026 ShoppingJPA - Lập trình Web
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Validation phía client cho mọi form có class "needs-validation" (dùng ở Phần B)
document.querySelectorAll('form.needs-validation').forEach(function (form) {
  form.addEventListener('submit', function (e) {
    if (!form.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
    form.classList.add('was-validated');
  });
});
// Ô có data-match="#id" phải trùng giá trị với ô #id (nhập lại mật khẩu)
document.querySelectorAll('[data-match]').forEach(function (el) {
  var other = document.querySelector(el.dataset.match);
  function check() { el.setCustomValidity(el.value !== other.value ? 'Không khớp' : ''); }
  el.addEventListener('input', check);
  other.addEventListener('input', check);
});
</script>
</body>
</html>