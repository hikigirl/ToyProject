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
		<h1>게시판 
			<c:if test="${map.search=='n'}">
			<small>목록</small>
			</c:if>
			
			<c:if test="${map.search=='y'}">
			<small>검색 결과</small>
			</c:if>
		</h1>
		<c:if test="${map.search=='y'}">
		<div id="labelsearch">'${map.word}'(으)로 검색한 결과가 ${list.size()}건 있습니다.</div>
		</c:if>
		
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
					<a href="/toy/board/view.do?seq=${dto.seq}&column=${map.column}&word=${map.word}">${dto.subject}</a>
					
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
		
		<!-- 검색창 -->
		<form action="/toy/board/list.do" id="searchForm" method="get">
			<select name="column">
				<option value="subject">제목</option>
				<option value="content">내용</option>
				<option value="name">이름</option>
			</select>
			<input type="text" class="long" required name="word" />
			<input type="submit" value="검색하기" />
		</form>
		
		<div>
			<c:if test="${not empty id}">
			<!-- 글쓰기 페이지.. -->
			<button type="button" class="add primary" onclick="location.href='/toy/board/add.do';">글쓰기</button>
			</c:if>
		</div>
	</div>
	
	<script>
		<c:if test="${map.search=='y'}">
		
		$('select[name=column]').val('${map.column}');
		$('input[name=word]').val('${map.word}');
		</c:if>
	</script>
	
</body>
</html>