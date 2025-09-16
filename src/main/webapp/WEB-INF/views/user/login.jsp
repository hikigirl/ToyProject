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
		<h1>회원 <small>로그인</small></h1>
		<form method="post" action="/toy/user/login.do">
		
		<table class="vertical content">
			<tr>
				<th>아이디</th>
				<td><input type="text" name="id" id="id" required class="short"/></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" name="pw" id="pw" required class="short"/></td>
			</tr>
		</table>
		
		<div>
			<button class="login primary" type="submit">로그인</button>
			<button type="button" class="back" onclick="location.href='toy/index.do';">돌아가기</button>
		</div>
		
		</form>
		
	</div>
	
	<!-- 개발용 코드(나중에 지워야함) -->
	<hr />
	<div style="display:flex;">
		<form action="/toy/user/login.do" method="post">
			<input type="hidden" name="id" value="hong"/>
			<input type="hidden" name="pw" value="1111"/>
			<input type="submit" name="id" value="hong(일반사용자)"/>
		</form>
		<form action="/toy/user/login.do" method="post">
			<input type="hidden" name="id" value="catty"/>
			<input type="hidden" name="pw" value="1111"/>
			<input type="submit" name="id" value="catty(일반사용자)"/>
		</form>
		<form action="/toy/user/login.do" method="post">
			<input type="hidden" name="id" value="dog"/>
			<input type="hidden" name="pw" value="1111"/>
			<input type="submit" name="id" value="dog(일반사용자)"/>
		</form>
		<form action="/toy/user/login.do" method="post">
			<input type="hidden" name="id" value="tiger"/>
			<input type="hidden" name="pw" value="1111"/>
			<input type="submit" name="id" value="tiger(관리자)"/>
		</form>
		
	</div>
	
	
</body>
</html>