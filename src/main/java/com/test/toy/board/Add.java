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

@WebServlet(value = "/board/add.do")
public class Add extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		//Add.java
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/board/add.jsp");
		dispatcher.forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// AddOk.java역할(dopost)
		//req.setCharacterEncoding("UTF-8");  
		//post방식에서 인코딩하는것 -> 매 페이지 작성하기 번거로워서 필터를 통해 구현해보기
		String subject = req.getParameter("subject");
		String content = req.getParameter("content");
		//System.out.println(subject);
		//System.out.println(content);
		
		BoardDAO dao = new BoardDAO();
		BoardDTO dto = new BoardDTO();
		dto.setSubject(subject);
		dto.setContent(content);
		
		HttpSession session = req.getSession();
		dto.setId(session.getAttribute("id").toString()); 
		
		//crud 작업의 마무리 코드 -> 코드조각 등록 추천...
		if (dao.add(dto) > 0) {
			resp.sendRedirect("/toy/board/list.do");
		} else {
			resp.getWriter().print("<html><meta charset='UTF-8'><script>alert('글쓰기에 실패하였습니다.'); history.back();</script></html>");
			resp.getWriter().close();
		}
		
	}
	
}