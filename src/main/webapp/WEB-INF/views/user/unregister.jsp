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
		<h1>회원 <small>탈퇴</small></h1>
		
		<form action="/toy/user/unregister.do" method="POST">
		<div>
			<button class="out primary" type="submit">탈퇴하기</button>
			<button type="button" class="back" onclick="location.href='/toy/index.do';">돌아가기</button>
		</div>
		</form>
		
	</div>
	
</body>
</html>