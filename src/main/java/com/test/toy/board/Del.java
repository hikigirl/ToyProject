package com.test.toy.board;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.test.toy.board.model.BoardDAO;

@WebServlet(value = "/board/del.do")
public class Del extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		//Del.java
		String seq = req.getParameter("seq");
		
		//seq를 여기서 사용하지 않고 jsp에서 사용하기 위해 넘겨줌
		req.setAttribute("seq", seq);
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/board/del.jsp");
		dispatcher.forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// delok.do 역할
		String seq = req.getParameter("seq");
		BoardDAO dao = new BoardDAO();
		
		
		if (dao.del(seq) > 0) {
			resp.sendRedirect("/toy/board/list.do");
		} else {
			resp.getWriter().print("<html><meta charset='UTF-8'><script>alert('글쓰기에 실패하였습니다.'); history.back();</script></html>");
			resp.getWriter().close();
		}
		
	}
	
}