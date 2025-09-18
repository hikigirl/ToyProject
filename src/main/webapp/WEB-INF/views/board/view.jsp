<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%@include file="/WEB-INF/views/inc/asset.jsp"%>

</head>
<body>
	<%@include file="/WEB-INF/views/inc/header.jsp"%>
	<div id="main">
		<h1>
			게시판 <small>보기</small>
		</h1>

		<table class="vertical" id="view">
			<tr>
				<th>번호</th>
				<td>${dto.seq}</td>
			</tr>
			<tr>
				<th>이름</th>
				<td>${dto.name}(${dto.id})</td>
			</tr>
			<tr>
				<th>날짜</th>
				<td>${dto.regdate}</td>
			</tr>
			<tr>
				<th>조회수</th>
				<td>${dto.readcount}</td>
			</tr>
			<tr>
				<th>제목</th>
				<td>${dto.subject}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>${dto.content}</td>
			</tr>
		</table>


		<!-- 댓글 목록 -->
		<table id="comment">
		<c:forEach items="${clist}" var="cdto">
			<tr>
				<td class="commentContent">
					<div>${cdto.content}</div>
					<div>${cdto.regdate}</div>
				</td>
				<td class="commentInfo">
					<div>
						<div>${cdto.name}(${cdto.id})</div>
						<div>
							<span class="material-symbols-outlined">edit_note</span> <span
								class="material-symbols-outlined">delete</span>
						</div>
					</div>
				</td>
			</tr>
		</c:forEach>
		</table>
		
		<div id="loading" style="text-align: center; display: none;">
		<img src="/toy/asset/images/loading_gray.gif" alt="loading.gif" />
		</div>
		
		<!-- 댓글 더보기 버튼 -->
		<div style="text-align: center;">
			<button class="comment" id="btnMoreComment" type="button">댓글 더보기</button>
		</div>
		
		<!-- 댓글 쓰기 -->
		<form id="addCommentForm">

			<table id="addComment">
				<tr>
					<td><input type="text" name="content" class="full" required /></td>
					<td><button id="btnAddComment" class="comment" type="button">댓글쓰기</button></td>
				</tr>

			</table>

		</form>


		<!-- 수정, 삭제, 돌아가기 버튼 -->
		<div>

			<%-- 현재로그인: ${id}
			작성자 : ${dto.id} --%>
			<c:if test="${not empty id and (id==dto.id || lv == '2')}">
				<button type="button" class="edit primary"
					onclick="location.href='/toy/board/edit.do?seq=${dto.seq}';">수정하기</button>
				<button type="button" class="del primary"
					onclick="location.href='/toy/board/del.do?seq=${dto.seq}';">삭제하기</button>
			</c:if>

			<button type="button" class="back"
				onclick="location.href='/toy/board/list.do?column=${column}&word=${word}';">목록보기</button>
			<!-- <button type="button" class="back" onclick="history.back();">목록보기</button> -->
		</div>

	</div>

	<script>
		$('#btnAddComment').click(() => {
			//alert();
			// $.ajax({
			// 	type: 'POST',
			// 	url: '/toy/board/addcomment.do',
			// 	data: {},
			// 	dataType: 'json',
			// 	success: function(result) {
	
			// 	},
			// 	error: function(a, b, c) {
			// 		console.log(a, b, c);
			// 	}
			// });
	
			$.post('/toy/board/addcomment.do', {
				//전송데이터
				content: $('input[name=content]').val(),
				bseq: ${dto.seq}
			}, function(result) {
				//alert(result.result);
				
				
				
				//댓글 목록에 내가 방금 쓴 댓글도 반영되도록 하기
				//목록 갱신
				
				//새로 작성한 댓글만 화면에 동적으로 추가
				//result 내부에 dto객체가 새로 생겼음
				let temp = `
				<tr>
					<td class="commentContent">
						<div>\${result.dto.content}</div>
						<div>\${result.dto.regdate}</div>
					</td>
					<td class="commentInfo">
						<div>
							<div>\${result.dto.name}(\${result.dto.id})</div>
							<div>
								<span class="material-symbols-outlined">edit_note</span>
								<span class="material-symbols-outlined">delete</span>
							</div>
						</div>
					</td>
				</tr>
				
				`;
				
				$('#comment tbody').prepend(temp);
				$('input[name=content]').val('');
				
			}, 'json').fail(function(a,b,c){
				console.log(a, b, c);
			});
	
		});
	
		//처음 로드되는 댓글의 rownum: 1~10
		// 11~15, 16~20, 21~25...
		let begin = 11;
		
		$('#btnMoreComment').click(() => {
			//alert();
			$('#loading').show();
			setTimeout(more, 1000);
			
			
			
		});
		
		function more() {
			$.get('/toy/board/morecomment.do', {
				bseq: ${dto.seq},
				begin: begin
			}, function(result) {
				if(result.length > 0){
					//댓글 5개를 화면에 출력
					result.forEach(obj => {
						let temp = `
							<tr>
								<td class="commentContent">
									<div>\${obj.content}</div>
									<div>\${obj.regdate}</div>
								</td>
								<td class="commentInfo">
									<div>
										<div>\${obj.name}(\${obj.id})</div>
										<div>
											<span class="material-symbols-outlined">edit_note</span>
											<span class="material-symbols-outlined">delete</span>
										</div>
									</div>
								</td>
							</tr>
							
							`;
						$('#comment tbody').append(temp);
					});
					
					
					begin += 5; //성공했을 때 5를 증가
				} else {
					alert('더 이상 댓글이 없습니다.');
				}
				
				
				$('#loading').hide();
				
			}, 'json').fail(function(a,b,c){
				console.log(a,b,c);
			});
		}
	
	</script>

</body>
</html>