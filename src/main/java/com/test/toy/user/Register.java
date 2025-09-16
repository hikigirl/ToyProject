package com.test.toy.user;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import com.test.toy.user.model.UserDAO;
import com.test.toy.user.model.UserDTO;

@WebServlet(value = "/user/register.do")
public class Register extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		//Register.java(doget), 
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/user/register.jsp");
		dispatcher.forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// RegisterOK.java(dopost)
		//1. 데이터 가져오기
		//2. DB작업 - insert
		//3. 마무리
		
		try {
			MultipartRequest multi = new MultipartRequest(
					req, 
					req.getServletContext().getRealPath("/asset/pic"), 
					1024*1024*10,
					"UTF-8",
					new DefaultFileRenamePolicy());
			System.out.println(req.getServletContext().getRealPath("/asset/pic"));
			
			//req가 작동을 안함(첨부파일때문에)
			String id = multi.getParameter("id");
			String pw = multi.getParameter("pw");
			String name = multi.getParameter("name");
			String email = multi.getParameter("email");
			String pic = multi.getFilesystemName("attach");
			String intro = multi.getParameter("intro");
			
			UserDAO dao = new UserDAO();
			UserDTO dto = new UserDTO();
			dto.setId(id);
			dto.setPw(pw);
			dto.setName(name);
			dto.setEmail(email);
			dto.setPic(pic);
			dto.setIntro(intro);
			
			int result = dao.register(dto); //1 or 0
			
			if (result > 0) {
				//회원가입 성공
				resp.sendRedirect("/toy/index.do");
				
			} else {
//				resp.setContentType("text/html");//기본값이 html이라 생략
//				resp.setCharacterEncoding("UTF-8"); //한글 안써서 생략
				resp.getWriter().print("<script>alert('register failed'); history.back();</script>");
				resp.getWriter().close();
			}
			
			
			
		} catch (Exception e) {
			// handle exception
			System.out.println("Register.doPost()");
			e.printStackTrace();
		}
		
	}
}

