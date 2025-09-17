<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<%@include file="/WEB-INF/views/inc/asset.jsp"%>

</head>
<body>
	<%@include file="/WEB-INF/views/inc/header.jsp"%>
	<div id="main">
		<h1>게시판 <small>목록</small></h1>
		
		<table id="list">
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>이름</th>
				<th>날짜</th>
				<th>조회수</th>
			</tr>
			<c:forEach items="${list}" var="dto">
			<tr>
				<td>${dto.seq}</td>
				<td>
					<a href="/toy/board/view.do?seq=${dto.seq}">${dto.subject}</a>
					
					<c:if test="${dto.isnew < 1}">
						<span class="isnew">new</span>
					</c:if>
				</td>
				<td>${dto.name}</td>
				<td>
					<%-- <fmt:parseDate value="${dto.regdate}" var="regdate" pattern="yyyy-MM-dd HH:mm:ss"></fmt:parseDate>
					<fmt:formatDate value="${regdate}" pattern="yyyy-MM-dd"/> --%>
					${dto.regdate}
				</td>
				<td>${dto.readcount}</td>
			</tr>
			</c:forEach>
		</table>
		
		<div>
			<!-- 글쓰기 페이지.. -->
			<button type="button" class="add primary" onclick="location.href='/toy/board/add.do';">글쓰기</button>
		</div>
	</div>
	
</body>
</html>