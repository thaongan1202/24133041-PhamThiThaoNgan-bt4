<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - ShoppingJPA</title>
</head>
<body>
    <h1>Xin chào <c:out value="${account.fullname}"/></h1>

    <h2>10 video mới nhất</h2>
    <c:if test="${empty videos}"><p>Chưa có video đang hoạt động.</p></c:if>
    <div class="row row-cols-1 row-cols-md-3 g-3">
        <c:forEach items="${videos}" var="video">
            <div class="col"><article class="card h-100">
                <c:choose>
                    <c:when test="${fn:startsWith(video.poster, 'http://') or fn:startsWith(video.poster, 'https://')}">
                        <img src="<c:out value='${video.poster}'/>" alt="Poster video">
                    </c:when>
                    <c:when test="${not empty video.poster}">
                        <c:url var="posterUrl" value="/image"><c:param name="fname" value="${video.poster}"/></c:url>
                        <img src="${posterUrl}" alt="Poster video">
                    </c:when>
                    <c:otherwise><img src="" alt="Chưa có poster"></c:otherwise>
                </c:choose>
                <div>
                    <h3><a href="<c:url value='/video'><c:param name='id' value='${video.videoId}'/></c:url>"><c:out value="${video.title}"/></a></h3>
                    <p><c:out value="${video.description}"/></p>
                    <small>Lượt xem: <c:out value="${video.views}"/></small>
                </div>
            </article></div>
        </c:forEach>
    </div>
    <p><a href="<c:url value='/video'/>">Xem tất cả video →</a></p>
</body>
</html>
