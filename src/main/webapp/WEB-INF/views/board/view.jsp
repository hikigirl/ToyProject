<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
			<c:if test = "${not empty dto.attach}">
			<tr>
				<th>장소</th>
				<td><img src="/toy/asset/place/${dto.attach}" alt="${dto.attach}" id="imgPlace"/></td>
			</tr>
			<c:if test="${not empty lat}">
			<tr>
				<th>위치</th>
				<td>
					<div id="map"></div>
					<%-- ${lat}, ${lng} --%>
				</td>
			</tr>
			</c:if>
			</c:if>
			
			<tr>
				<th>해시태그</th>
				<td><input type="text" id="hashtag" class="full" /></td>
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
						
						<c:if test="${not empty id && (id == cdto.id|| lv=='2')}">
						<div>
							<span class="material-symbols-outlined" onclick =" edit(${cdto.seq})">edit_note</span>
							<span class="material-symbols-outlined" onclick =" del(${cdto.seq})">delete</span>
						</div>
						</c:if>
						
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
	
<!--------------------------------------------------------------------->
	
	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e002eba63b35b03451ac4917b7108dd6"></script>
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
								<span class="material-symbols-outlined" onclick = "edit(\${result.dto.seq});">edit_note</span>
								<span class="material-symbols-outlined" onclick = "del(\${result.dto.seq});">delete</span>
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
							`;
						//익명 사용자: if('') -> false
						//인증 사용자: if('hong') -> true
						if('${id}' && ('${id}' == obj.id || ${lv==2})) {
							temp+=`		
								<div>
									<span class="material-symbols-outlined" onclick = "edit(\${obj.seq});">edit_note</span>
									<span class="material-symbols-outlined" onclick = "del(\${obj.seq});">delete</span>
								</div>
						
							`;	
						}
										
						temp+=`				
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
	
		//댓글 수정(형식 만들기) 함수
		function edit(seq) {
			
			$('.commentEditRow').remove();
			
			//let content = '수정할 댓글입니다.';
			let content = $(event.target).parents('tr').children().eq(0).children().eq(0).text();
			$(event.target).parents('tr').after(`
					
					<tr class="commentEditRow">
						<td><input type="text" name="content" class="full" required value="\${content}" id="txtComment"></td>
						<td class="commentEdit">
							<span class="material-symbols-outlined" onclick="editComment(\${seq});">edit_square</span>
							<span class="material-symbols-outlined" onclick="$(event.target).parents('tr').remove();">close</span>
						</td>
					</tr>
						
				`);
		}
		
		function editComment(seq) {
			/* alert(seq); */
			//alert($('#txtComment').val());
			
			let div = $(event.target).parents('tr').prev().children().eq(0).children().eq(0);
			let tr = $(event.target).parents('tr');
			
			
			//ajax로 서버에 넘겨서 update문
			$.post('/toy/board/editcomment.do', {
				seq: seq,
				content: $('#txtComment').val()
			}, function(result) {
				if(result.result =='1') {
					//alert('수정 성공');
					div.text($('#txtComment').val());
					tr.remove();
				} else {
					alert('수정에 실패했습니다.');
				}
			}, 'json').fail(function(a,b,c) {
				console.log(a,b,c);
			});
		}
		
		//댓글 삭제 함수
		function del(seq) {
			$('.commentEditRow').remove();
			let tr = $(event.target).parents('tr');
			
			if(confirm('삭제하시겠습니까?')) {
				$.post('/toy/board/delcomment.do', {
					seq:seq
				}, function (result) {
					if(result.result==1) {
						alert('삭제 성공');
						//$(event.target).parents('tr').remove();
						//console.log(event.target);
						tr.remove();
					} else {
						alert('삭제에 실패했습니다.');
					}
				}, 'json')
				.fail(function(a,b,c) {
					console.log(a,b,c);
				});
			}
		}
		
		<c:if test="${not empty lat}">
		//지도를 담을 영역의 DOM 레퍼런스
		var container = document.getElementById('map');
	
		//지도를 생성할 때 필요한 기본 옵션
		var options = { 
			
			//지도의 중심좌표.
			center: new kakao.maps.LatLng(37.499349, 127.033245),
			
			//지도의 레벨(확대, 축소 정도)
			level: 3 
		};
	
		var map = new kakao.maps.Map(container, options);
		
		const path = '/toy/asset/images/studio.png';
		const size = new kakao.maps.Size(64, 64);
		const op = {
			offset: new kakao.maps.Point(32, 64)
		};
		const img = new kakao.maps.MarkerImage(path, size, op);
		
		const m1 = new kakao.maps.Marker({
			position: new kakao.maps.LatLng(${lat}, ${lng}),
			image:img
		});
		m1.setMap(map);
		map.panTo(m1.getPosition());
		
		</c:if>
		
		//해시태그 처리
		let taglist = '';
		<c:forEach items="${dto.hashtag}" var="tag">
			taglist += '${tag},';
		</c:forEach>
		
		$('#hashtag').val(taglist);
		
		const tagify = new Tagify(document.getElementById('hashtag'));
		
		tagify.on('click', (e) => {
			//alert(e.detail.data.value);
			location.href='/toy/board/list.do?tag=' + e.detail.data.value;
		});
		
	</script>

</body>
</html>