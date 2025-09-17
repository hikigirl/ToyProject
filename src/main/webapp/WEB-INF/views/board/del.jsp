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
		<h1>게시판 <small>삭제하기</small></h1>
		<form action="/toy/board/del.do" method="POST">
		
		
		<!-- 삭제버튼과 돌아가기 버튼 -->
		<div>
			<button class="del primary" type="submit">삭제하기</button>
			<button type="button" class="back" onclick="location.href='/toy/board/view.do?seq=${seq}';">목록보기</button>
		</div>
		<input type="hidden" name="seq" value="${seq}" />
		</form>
	</div>
	
</body>
</html>