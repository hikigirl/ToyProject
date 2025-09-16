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

@WebServlet(value = "/user/login.do")
public class Login extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		//Login.java
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/user/login.jsp");
		dispatcher.forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// loginok.java 역할(dopost)
		//1. 데이터 가져오기
		//2. DB작업 -> select
		//3. 마무리 - 인증 티켓 발급하기
		
		String id = req.getParameter("id");
		String pw = req.getParameter("pw");
		
		UserDAO dao = new UserDAO();
		UserDTO dto = new UserDTO();
		dto.setId(id);
		dto.setPw(pw);
		
		//int result = dao.login(dto); //1, 0
		UserDTO result = dao.login(dto); //dto, null
		
		if (result!=null) {
			//로그인 성공 -> 인증 티켓 발급(세션)
			HttpSession session = req.getSession();
			
			session.setAttribute("id", id); //인증 티켓
			session.setAttribute("name", result.getName());
			session.setAttribute("lv", result.getLv());
			
			session.setAttribute("info", result);
			
			resp.sendRedirect("/toy/index.do");
			
		} else {
			//로그인 실패
			resp.getWriter().print("<script>alert('login failed'); history.back();</script>");
			resp.getWriter().close();
		}
		
	}
	
}