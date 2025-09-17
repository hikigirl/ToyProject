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
		
		
		//JSP에게 전달
		req.setAttribute("dto", dto);
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/board/view.jsp");
		dispatcher.forward(req, resp);
	}
}