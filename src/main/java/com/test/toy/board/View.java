package com.test.toy.board;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.test.toy.board.model.BoardDAO;
import com.test.toy.board.model.BoardDTO;

@WebServlet(value = "/board/view.do")
public class View extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		//View.java
		HttpSession session = req.getSession();
		
		String seq = req.getParameter("seq");
		String column= req.getParameter("column");
		String word= req.getParameter("word");
		
		BoardDAO dao = new BoardDAO();
		
		if(session.getAttribute("read").toString().equals("n")) {
			//조회수 증가
			dao.updateReadCount(seq);
			session.setAttribute("read", "y");
		}
		
		BoardDTO dto = dao.get(seq);
		
		
		//DTO 내부 데이터 조작
		//제목과 내용에 들어간 < 와 >를 escape
		String subject = dto.getSubject();
		subject = subject.replace("<", "&lt;").replace(">", "&gt;");
		dto.setSubject(subject);
		
		String content = dto.getContent();
		content = content.replace("<", "&lt;").replace(">", "&gt;");
		dto.setContent(content);
		
		//검색어 부각시키기
		// - 오늘 <span style='background-color:gold; color:tomato;'>자바</span> 수업 중...
		if (((column != null && word != null) || (!column.equals("") && !word.equals(""))) && column.equals("content") ) {
			content = content.replace(word, "<span style='background-color:gold; color:tomato;'>"+ word +"</span>");
			dto.setContent(content);
		}
		
		
		
		//JSP에게 전달
		req.setAttribute("dto", dto);
		req.setAttribute("column", column);
		req.setAttribute("word", word);
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/board/view.jsp");
		dispatcher.forward(req, resp);
	}
}