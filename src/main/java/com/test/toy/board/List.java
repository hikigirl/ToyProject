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
		
		BoardDAO dao = new BoardDAO();
		
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
		
		
		//JSP에게 넘긴다
		req.setAttribute("list", list);
		//아직 검색에 관련된 값들을 jsp에 넘겨주지 않았음(map에 넣은 값)
		req.setAttribute("map", map); //검색어와 검색중인 컬럼이 담겨 있음
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/board/list.jsp");
		dispatcher.forward(req, resp);
	}
}