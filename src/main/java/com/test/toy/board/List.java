package com.test.toy.board;

import java.io.IOException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.test.toy.board.model.BoardDAO;
import com.test.toy.board.model.BoardDTO;

@WebServlet(value = "/board/list.do")
public class List extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		//List.java
		/*
		목록보기 -> list.do
		검색결과보기 -> query string을 포함
		*/
		String column = req.getParameter("column");
		String word = req.getParameter("word");
		String search = "n"; //목록보기(n), 검색하기(y)
		
		if ((column == null && word==null) || word.trim().equals("")) {
			search = "n";
		} else {
			search = "y";
		}
		
		//검색에 필요한 정보 저장용 hashmap
		Map<String, String> map = new HashMap<String, String>();
		
		map.put("column", column);
		map.put("word", word);
		map.put("search", search);
		
		HttpSession session = req.getSession();
		//조회수 증가 방지
		session.setAttribute("read", "n");
		
		//페이징
		//list.do -> 1페이지
		//list.do?page=1
		//list.do?page=2
		String page = req.getParameter("page");
		int nowPage = 0; 		//현재 페이지 번호
		int totalCount = 0;		//게시글 수 - 264개
		int pageSize = 10;		//한 페이지 당 보여줄 게시글 수
		int totalPage = 0;		//총 페이지 수(약 26~27페이지)
		int begin = 0;			//페이징 시작 위치
		int end = 0;			//페이징 끝 위치
		//페이지바를 또 페이징하기 위한 변수
		int n = 0;				//페이지바의 페이지 번호(링크에 출력되고있는 숫자)
		int loop = 0;			//페이지바 루프 변수
		int blockSize = 10;		//한번에 보여줄 페이지 번호 수
		
		if (page == null || page.equals("")) { 
			//쿼리스트링에 아무것도 없는경우
			nowPage = 1;
		} else {
			nowPage = Integer.parseInt(page);
		}
		//list.do?page=1 -> where rnum between 1 and 10
		//list.do?page=2 -> where rnum between 11 and 20
		begin = ((nowPage-1) * pageSize) + 1;
		end = begin + pageSize - 1;
		
		map.put("begin", begin+"");
		map.put("end", end+"");
		map.put("nowPage", nowPage+"");
		
		
		BoardDAO dao = new BoardDAO();
		
		//총 게시물 수 계산
		totalCount = dao.getTotalCount(map);
		//System.out.println(totalCount);
		totalPage = (int)Math.ceil((double)totalCount / pageSize);
		map.put("totalPage", totalPage+"");
		map.put("totalCount", totalCount+"");
		
		
		//해시태그 기능 관련 코드
		String tag = req.getParameter("tag");
		map.put("tag", tag);
		
		
		java.util.List<BoardDTO> list = dao.list(map);
		
		//데이터를 받아오고 아직 jsp에게 넘기기 전
		//데이터 조작
		
		Calendar now = Calendar.getInstance();
		String nowDate = String.format("%tF", now); //2025-09-17
				
		for (BoardDTO dto : list) {
			//날짜 조작 -> 오늘 날짜?
			String regdate = dto.getRegdate();
			if (regdate.startsWith(nowDate)) {
				//시간을 표시
				//System.out.println("오늘 쓴 글");
				dto.setRegdate(regdate.substring(11)); //시분초
			} else {
				//System.out.println("과거 쓴 글");
				dto.setRegdate(regdate.substring(0, 10));//연월일
			}
			
			//긴 제목 자르기
			String subject = dto.getSubject();
			if(subject.length() > 15 ) {
				subject = subject.substring(0, 15) + "..";
			}
			//태그 비활성화
			subject = subject.replace("<", "&lt;").replace(">", "&gt;");
			
			dto.setSubject(subject);
		}
		
		
		//페이지바(3번째 방법)
		String pagebar = "";
		
//		for(int i=1; i<=totalPage; i++) {
//			pagebar += 
//				String.format(" <a href='/toy/board/list.do?page=%d'>%d</a> ", i, i);			
//		}
		
		loop = 1; 	//루프 변수(10바퀴)
		n = ((nowPage - 1) / blockSize) * blockSize + 1; //페이지 번호
		
//		pagebar += "[이전 10페이지]";
		
		if (n == 1) {
			pagebar += String.format(" <a href='#!'>[이전 %d페이지]</a> ", blockSize);
		} else {
			pagebar += String.format(" <a href='/toy/board/list.do?page=%d'>[이전 %d페이지]</a> ", n - 1, blockSize);
		}
		
		while(!(loop>blockSize || n > totalPage)) {
			if(n==nowPage) {
				pagebar += String.format(" <a href='#!' style='color:tomato;'>%d</a> ", n);
				
			} else {
				pagebar += String.format(" <a href='/toy/board/list.do?page=%d'>%d</a> ", n, n);
				
			}
			loop++;
			n++;
		}
		
//		pagebar += "[다음 10페이지]";
		if (n >= totalPage) {
			pagebar += String.format(" <a href='#!'>[다음 %d페이지]</a> ", blockSize);
		} else {
			pagebar += String.format(" <a href='/toy/board/list.do?page=%d'>[다음 %d페이지]</a> ", n, blockSize);
		}
		
		
		
		
		
		//JSP에게 넘겨주는 값들
		req.setAttribute("list", list);
		//아직 검색에 관련된 값들을 jsp에 넘겨주지 않았음(map에 넣은 값)
		req.setAttribute("map", map); //검색어와 검색중인 컬럼이 담겨 있음
		//페이지 번호도 같이 넘겼음(map에 담아서)
		//페이지바를 넘김
		req.setAttribute("pagebar", pagebar);
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/board/list.jsp");
		dispatcher.forward(req, resp);
	}
}