<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<%@include file="/WEB-INF/views/inc/asset.jsp"%>

</head>
<body>
	<%@include file="/WEB-INF/views/inc/header.jsp"%>
	<div id="main">
		<h1>게시판 <small>수정하기</small></h1>
		<form action="/toy/board/edit.do" method="POST">
		
		<table class="vertical">
			<tr>
				<th>제목</th>
				<td><input type="text" id="subject" class="full" name="subject" required="required" value="${dto.subject}"/></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="content" id="content" class="full" required="required">${dto.content}</textarea></td>
			</tr>
		</table>
		<!-- 수정버튼과 돌아가기 버튼 -->
		<div>
			<button class="edit primary" type="submit">수정하기</button>
			<button type="button" class="back" onclick="location.href='/toy/board/list.do';">목록보기</button>
		</div>
		<input type="hidden" name="seq" value="${dto.seq}" />
		</form>
	</div>
	
</body>
</html>