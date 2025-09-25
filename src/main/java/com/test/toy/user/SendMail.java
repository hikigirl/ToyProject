package com.test.toy.user;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

@WebServlet(value = "/user/sendmail.do")
public class SendMail extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		//SendMail.java
		//1. 데이터 가져오기(email)
		//2. 인증번호 생성 -> 세션에 담기
		//3. 이메일 발송
		//4. 마무리
		
		//1. 데이터 가져오기
		String email = req.getParameter("email");
		
		//2. 5자리 인증번호 -> 0~89999에 10000을 더해 -> 10000~99999
		Random rnd = new Random();
		int validNumber = rnd.nextInt(90000) + 10000;
		req.getSession().setAttribute("validNumber", validNumber);
		
		int result = 0;
		
		try {
			MailSender sender = new MailSender();
			
			Map<String, String> map = new HashMap<String, String>();
			
			map.put("email", email);
			map.put("validNumber", validNumber + "");
			
			//sender.sendMail(map);
			sender.sendVerificationMail(map);
			result = 1;
		} catch (Exception e) {
			// handle exception
			System.out.println("SendMail.doGet()");
			e.printStackTrace();
		}
		
		resp.setContentType("application/json");
		JSONObject obj = new JSONObject();
		obj.put("result", result);
		
		resp.getWriter().print(obj.toString());
		resp.getWriter().close();
		
	
	}
}