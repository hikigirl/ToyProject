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
		<h1>게시판 <small>글쓰기</small></h1>
		<form action="/toy/board/add.do" method="POST">
		<table class="vertical">
			<tr>
				<th>제목</th>
				<td><input type="text"" id="subject" class="full" name="subject" required="required" /></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="content" id="content" class="full" required="required"></textarea></td>
			</tr>
		</table>
		<!-- 쓰기버튼과 돌아가기 버튼 -->
		<div>
			<button class="add primary" type="submit">글쓰기</button>
			<button type="button" class="back" onclick="location.href='/toy/board/list.do';">목록보기</button>
		</div>
		</form>
	</div>
	
</body>
</html>