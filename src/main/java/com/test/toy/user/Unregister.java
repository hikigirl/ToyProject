package com.test.toy.user;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.test.toy.user.model.UserDAO;
import com.test.toy.user.model.UserDTO;

@WebServlet(value = "/user/unregister.do")
public class Unregister extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		//Unregister.java
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/user/unregister.jsp");
		dispatcher.forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		//회원 탈퇴
		//1. 활동유무 컬럼을 탈퇴로 바꿈(ing-> 0)
		//2. 개인정보 관련 내용은 파기(update)
		
		HttpSession session = req.getSession();
		String id = session.getAttribute("id").toString();
		UserDAO dao = new UserDAO();
		if(dao.unregister(id) > 0) {
			session.invalidate(); //로그아웃 처리
			resp.sendRedirect("/toy/index.do");
		} else {
			resp.getWriter().print("<html><meta charset='UTF-8'><script>alert('탈퇴 실패'); history.back();</script></html>");
			resp.getWriter().close();
		}
		
	}
	
}