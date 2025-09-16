package com.test.toy.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

public class EncodingFilter implements Filter{

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		
		//System.out.println("필터생성");
	}
	
	@Override
	public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
		
		//System.out.println("로그기록");
		//System.out.println(((HttpServletRequest)req).getRequestURI());
		
		req.setCharacterEncoding("UTF-8"); //모든 서블릿에 대해 인코딩
		resp.setCharacterEncoding("UTF-8");
		
		//다음 필터 혹은 서블릿을 호출하고 마무리되어야...
		chain.doFilter(req, resp);
	}
	
	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		//System.out.println("필터소멸");
	}

}
