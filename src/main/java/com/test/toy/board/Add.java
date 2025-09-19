package com.test.toy.board;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
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
		
		//첨부 파일 기능 추가 -> req를 multi로 변경하는 작업
		MultipartRequest multi = new MultipartRequest(
				req,
				req.getServletContext().getRealPath("/asset/place"),
				1024*1024*30,
				"UTF-8",
				new DefaultFileRenamePolicy());
		
		System.out.println(req.getServletContext().getRealPath("/asset/place")); //찾아가서 업로드되었는지 확인해볼 경로 출력
		
		
		String subject = multi.getParameter("subject");
		String content = multi.getParameter("content");
		String attach = multi.getFilesystemName("attach");
		String hashtag = multi.getParameter("hashtag");
		//System.out.println(subject);
		//System.out.println(content);
		//System.out.println(hashtag); //해시태그 작성하지 않을 경우 빈 문자열
		
		BoardDAO dao = new BoardDAO();
		BoardDTO dto = new BoardDTO();
		dto.setSubject(subject);
		dto.setContent(content);
		dto.setAttach(attach);
		
		HttpSession session = req.getSession();
		dto.setId(session.getAttribute("id").toString()); 
		
		int result = dao.add(dto);
		
		//방금 쓴 글의 PK를 알아내기(태그기능 구현 위함)
		String bseq = dao.getBseq();
		
		//해시태그 
		if(!hashtag.equals("")) { //빈 문자열이 아니라면
			//[{"value":"게시판"},{"value":"태그"},{"value":"프로젝트"},{"value":"JSP"}]
			//JSONSimple을 이용한 parsing
			
			try {
				JSONParser parser = new JSONParser();
				JSONArray arr = (JSONArray)parser.parse(hashtag);
				for(Object obj : arr) {
					JSONObject tag = (JSONObject)obj;
					String tagName = tag.get("value").toString();
					
					//System.out.println(tagName);
					
					//해시태그 -> DB 추가
					//tagName -> unique 제약 걸려있음
					String hseq = dao.addHashtag(tagName);
					
					//연결 테이블 -> 관계 추가(tblTagging에 insert)
					Map<String, String> map = new HashMap<String, String>();
					map.put("bseq", bseq);
					map.put("hseq", hseq);
					
					dao.addTagging(map);
					
					
				}
				
				
			} catch (Exception e) {
				// handle exception
				System.out.println("Add.doPost()");
				e.printStackTrace();
			}
			
		}
		
		
		
		//crud 작업의 마무리 코드 -> 코드조각 등록 추천...
		if (result > 0) {
			resp.sendRedirect("/toy/board/list.do");
		} else {
			resp.getWriter().print("<html><meta charset='UTF-8'><script>alert('글쓰기에 실패하였습니다.'); history.back();</script></html>");
			resp.getWriter().close();
		}
		
	}
	
}