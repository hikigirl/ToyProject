<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<%@include file="/WEB-INF/views/inc/asset.jsp"%>
	<link rel="stylesheet" href="/toy/asset/css/tagify.css" />
	<script src="/toy/asset/js/tagify.js"></script>
</head>
<body>
	<%@include file="/WEB-INF/views/inc/header.jsp"%>
	<div id="main">
		<h1>게시판 <small>글쓰기</small></h1>
		<form action="/toy/board/add.do" method="POST" enctype="multipart/form-data">
		<table class="vertical">
			<tr>
				<th>제목</th>
				<td><input type="text" id="subject" class="full" name="subject" required="required" /></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="content" id="content" class="full" required="required"></textarea></td>
			</tr>
			
			
			<tr>
				<th>장소</th>
				<td><input type="file" name="attach" class="full" accept="image/*"/></td>
			</tr>
		
			<tr>
				<th>해시태그</th>
				<td><input type="text" id="hashtag" class="full" name="hashtag" /></td>
			</tr>
			<tr>
				<th>비밀글</th>
				<td><label><input type="checkbox" name="secret" value="1"/> 비밀글(작성자/관리자만 열람 가능)</label></td>
			</tr>
			<c:if test="${lv=='2'}">
			<tr>
				<th>공지</th>
				<td><label><input type="checkbox" name="notice" value="1"/> 공지(관리자만 작성 가능)</label></td>
			</tr>
			</c:if>
			
		</table>
		<!-- 쓰기버튼과 돌아가기 버튼 -->
		<div>
			<button class="add primary" type="submit">글쓰기</button>
			<button type="button" class="back" onclick="location.href='/toy/board/list.do';">목록보기</button>
		</div>
		</form>
	</div>
	<script>
	
		const hashtag = document.getElementById('hashtag');
		new Tagify(hashtag);
		
		//window.onclick = function() {
			//alert(document.getElementById('hashtag').value); 
			// --> json 형태
			//[
			//	{"value":"강아지"},
			//	{"value":"고양이"},
			//	{"value":"병아리"}
			//]
		//};
		
	</script>
</body>
</html>