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
		<h1>회원 <small>가입하기</small></h1>
		
		<form method="post" action="/toy/user/register.do" enctype="multipart/form-data">
		<table class="vertical">
			<tr>
				<th>아이디</th>
				<td><input type="text" id="id" class="short" name="id" required/></td>
			</tr>
			<tr>
				<th>암호</th>
				<td><input type="password" id="pw" class="short" name="pw" required/></td>
			</tr>
			<tr>
				<th>이름</th>
				<td><input type="text" id="name" class="short" name="name" required/></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><input type="text" id="email" class="long" name="email" required/></td>
			</tr>
			<tr>
				<th>사진</th>
				<td><input type="file" id="attach" class="long" name="attach" /></td>
			</tr>
			<tr>
				<th>소개</th>
				<td><textarea name="intro" id="intro" class="long"></textarea></td>
			</tr>
		
		</table>
		
		<div>
			<button type="button" class="back" onclick="location.href='toy/index.do';">돌아가기</button>
			<button class="in primary" type="submit">가입하기</button>
		</div>
		
		</form>
		
		
	</div>
	
</body>
</html>