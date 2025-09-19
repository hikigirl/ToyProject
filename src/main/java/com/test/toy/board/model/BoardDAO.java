package com.test.toy.board.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.test.util.DBUtil;

public class BoardDAO {

	private DBUtil util;
	private Connection conn;
	private Statement stat;
	private PreparedStatement pstat;
	private ResultSet rs;

	public BoardDAO() {
		try {
			util = new DBUtil();
			conn = util.open();
			stat = conn.createStatement();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int add(BoardDTO dto) {
		// add.do에서 호출하였음
		try {
			String sql = "INSERT INTO TBLBOARD (seq, subject, content, id, regdate, readcount, attach) VALUES (seqBoard.nextVal, ?, ?, ?, DEFAULT, DEFAULT, ?)";

			//현재 장소에 특정 데이터가 없는 경우
			//1. 이 장소에서 특정 데이터를 가져올 수 있는지? -> 스스로
			//2. 현재 객체를 호출한 쪽에서 특정 데이터를 전달해줄 수 있는지? -> 전달
			//로그인한 유저의 아이디 -> 세션에 저장되어 있음
			// - DAO는 세션에 접근할 수 있는가? -> dao는 서블릿이 아니라서 불가능
			// - add.do는 request 객체를 갖고있어서 세션에 접근 가능
			// - -> Add.java에서 세션값을 dto에 넣어서 여기로 가져옴 
			
			pstat = conn.prepareStatement(sql);
			pstat.setString(1, dto.getSubject());
			pstat.setString(2, dto.getContent());
			pstat.setString(3, dto.getId());
			pstat.setString(4, dto.getAttach());

			return pstat.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	public List<BoardDTO> list(Map<String, String> map) {
		//list.do에서 호출하였음
		try {
			//목록보기 -> SELECT * FROM vwBoard
			//검색하기 -> SELECT * FROM vwBoard WHERE 조건
			
			String where = "";
			if(map.get("search").equals("y")) {
				//where = "조건";
				//where 컬럼명 like '%검색어%';
				where = String.format("WHERE %s like '%%%s%%'", map.get("column"), map.get("word"));
			}
//			SELECT * FROM (SELECT a.*, rownum AS rnum FROM vwBoard a)
//			WHERE rnum BETWEEN 1 AND 10
			String sql = "";
			if(map.get("tag") == null) {
				sql = String.format("SELECT * FROM (SELECT a.*, rownum AS rnum FROM vwBoard a %s) WHERE rnum BETWEEN %s AND %s", 
						where, map.get("begin"), map.get("end"));
			} else {
				sql = String.format("SELECT * FROM (SELECT a.*, rownum AS rnum FROM vwBoard a) b INNER JOIN tbltagging t ON b.seq=t.bseq INNER JOIN tblhashtag h ON h.seq=t.hseq WHERE rnum BETWEEN %s AND %s AND h.hashtag = '%s'",
						map.get("begin"), map.get("end"), map.get("tag"));
			}
			
			
			
			stat = conn.createStatement();
			rs = stat.executeQuery(sql);
			
			List<BoardDTO> list = new ArrayList<BoardDTO>();
			
			while (rs.next()) {
				
				BoardDTO dto = new BoardDTO();
				
				dto.setSeq(rs.getString("seq"));
				dto.setSubject(rs.getString("subject"));
				dto.setId(rs.getString("id"));
				dto.setReadcount(rs.getString("readcount"));
				dto.setRegdate(rs.getString("regdate"));
				
				dto.setName(rs.getString("name"));
				dto.setIsnew(rs.getDouble("isnew"));
				dto.setCommentCount(rs.getString("commentCount"));
				
				list.add(dto);				
			}	
			
			return list;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
		
	}

	public BoardDTO get(String seq) {
		//view.do에서 호출되었음
		//edit.do에서 호출되었음
		try {
			
			String sql = "SELECT tblBoard.*, (SELECT name FROM tblUser WHERE id = tblBoard.id) AS name FROM tblBoard WHERE seq = ?";
			
			pstat = conn.prepareStatement(sql);
			pstat.setString(1, seq);
			
			rs = pstat.executeQuery();
			
			if (rs.next()) {
				
				BoardDTO dto = new BoardDTO();
				
				dto.setSeq(rs.getString("seq"));
				dto.setSubject(rs.getString("subject"));
				dto.setId(rs.getString("id"));
				dto.setReadcount(rs.getString("readcount"));
				dto.setRegdate(rs.getString("regdate"));
				dto.setContent(rs.getString("content"));
				dto.setName(rs.getString("name"));
				dto.setAttach(rs.getString("attach"));
				
				//해시태그 추가
				sql = "SELECT h.hashtag FROM tblBoard b INNER JOIN tbltagging t ON b.SEQ = t.bseq INNER JOIN tblhashtag h ON h.SEQ = t.hseq WHERE b.seq = ?";
				pstat = conn.prepareStatement(sql);
				pstat.setString(1, seq);
				rs=pstat.executeQuery();
				
				List<String> tlist = new ArrayList<String>();
				while (rs.next()) {
					tlist.add(rs.getString("hashtag"));
				}
				
				dto.setHashtag(tlist);
				
				return dto;				
			}	
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}

	public void updateReadCount(String seq) {
		//view.do에서 호출되었음
		try {

			String sql = "UPDATE TBLBOARD SET readcount = readcount + 1 WHERE seq=?";

			pstat = conn.prepareStatement(sql);
			pstat.setString(1, seq);

			pstat.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	public int edit(BoardDTO dto) {
		// edit.do에서 호출되었음
		
		try {

			String sql = "UPDATE TBLBOARD SET subject = ?, content = ? WHERE seq = ?";

			pstat = conn.prepareStatement(sql);
			pstat.setString(1, dto.getSubject());
			pstat.setString(2, dto.getContent());
			pstat.setString(3, dto.getSeq()); //edit.do에 seq를 안담아보냈다.. 처리하고 다시 왓음(처리한 과정에 대해 다시 생각해보기)
			

			return pstat.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return 0;
	}

	public int del(String seq) {
		//del.do에서 호출
		try {

			String sql = "DELETE FROM TBLBOARD WHERE seq = ?";

			pstat = conn.prepareStatement(sql);
			pstat.setString(1, seq);

			return pstat.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	public int getTotalCount(Map<String, String> map) {
		// list.do에서 호출하였음
		
		try {

			String where = "";
			if(map.get("search").equals("y")) {
				//where = "조건";
				//where 컬럼명 like '%검색어%';
				where = String.format("WHERE %s like '%%%s%%'", map.get("column"), map.get("word"));
			}
			
			String sql = "SELECT count(*) AS cnt FROM VWBOARD " + where;

			pstat = conn.prepareStatement(sql);

			rs = pstat.executeQuery();

			if (rs.next()) {
				return rs.getInt("cnt");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return 0;
	}

	public int addComment(CommentDTO dto) {
		// addcomment.do에서 호출하였음
		
		//insert 작업
		try {

			String sql = "INSERT INTO tblComment (seq, content, id, regdate, bseq) VALUES (seqComment.nextVal, ?, ?, DEFAULT, ?)";

			pstat = conn.prepareStatement(sql);
			pstat.setString(1, dto.getContent());
			pstat.setString(2, dto.getId());
			pstat.setString(3, dto.getBseq());

			return pstat.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return 0;
	}

	public List<CommentDTO> listComment(String bseq) {
		
		//view.java에서 호출하였음
		try {
			
			String sql = "SELECT * FROM (SELECT	tblComment.*, (SELECT name FROM tblUser WHERE id = tblComment.id) AS name FROM tblComment WHERE bseq = ? ORDER BY seq DESC) WHERE rownum <= 10";
			
			pstat = conn.prepareStatement(sql);
			pstat.setString(1, bseq);
			
			rs = pstat.executeQuery();
			
			ArrayList<CommentDTO> list = new ArrayList<CommentDTO>();
			
			while (rs.next()) {
				
				CommentDTO dto = new CommentDTO();
				
				dto.setSeq(rs.getString("seq"));
				dto.setContent(rs.getString("content"));
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setRegdate(rs.getString("regdate"));
				dto.setBseq(rs.getString("bseq"));
				
				list.add(dto);				
			}	
			
			return list;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}

	public CommentDTO getComment() {
		// addcomment.do에서 호출, 방금 쓴 댓글을 select
		try {
			
			String sql = "SELECT tblComment.*, (SELECT name FROM tblUser WHERE id = tblComment.id) AS name FROM tblComment WHERE seq = (SELECT max(seq) FROM tblcomment)";
			
			stat = conn.createStatement();
			rs = stat.executeQuery(sql);
			
			if (rs.next()) {
				
				CommentDTO dto = new CommentDTO();
				
				dto.setSeq(rs.getString("seq"));
				dto.setContent(rs.getString("content"));
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setRegdate(rs.getString("regdate"));
				dto.setBseq(rs.getString("bseq"));
				
				return dto;				
			}	
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}

	public List<CommentDTO> moreComment(Map<String, String> map) {
		// morecomment.do에서 호출
		try {
			
			String sql = "SELECT * FROM (SELECT a.*, rownum AS rnum FROM (SELECT tblComment.*, (SELECT name FROM tblUser WHERE id = tblComment.id) AS name FROM tblComment WHERE bseq = ? ORDER BY seq DESC) a) WHERE rnum BETWEEN ? AND ? + 4";
			
			pstat = conn.prepareStatement(sql);
			pstat.setString(1, map.get("bseq"));
			pstat.setString(2, map.get("begin"));
			pstat.setString(3, map.get("begin"));
			
			rs = pstat.executeQuery();
			
			ArrayList<CommentDTO> list = new ArrayList<CommentDTO>();
			
			while (rs.next()) {
				
				CommentDTO dto = new CommentDTO();
				
				dto.setSeq(rs.getString("seq"));
				dto.setContent(rs.getString("content"));
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setRegdate(rs.getString("regdate"));
				dto.setBseq(rs.getString("bseq"));
				
				list.add(dto);			
			}	
			
			return list;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}

	public int editComment(CommentDTO dto) {
		// editcomment.do에서 호출하였음
		try {

			String sql = "UPDATE TBLCOMMENT SET content = ? WHERE seq = ?";

			pstat = conn.prepareStatement(sql);
			pstat.setString(1, dto.getContent());
			pstat.setString(2, dto.getSeq());

			return pstat.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	public int delComment(String seq) {
		// delcomment.do에서 호출
		try {

			String sql = "DELETE FROM TBLCOMMENT WHERE seq = ?";

			pstat = conn.prepareStatement(sql);
			pstat.setString(1, seq);

			return pstat.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return 0;
	}

	public String getBseq() {
		// add.do에서 호출(태그 기능 구현위함)
		try {

			String sql = "SELECT max(seq) AS seq FROM TBLBOARD";

			stat = conn.createStatement();
			rs = stat.executeQuery(sql);

			if (rs.next()) {

				return rs.getString("seq");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}

	public String addHashtag(String tagName) {
		// add.do에서 호출(태그 기능)
		try {
			
			String sql = "SELECT seq FROM tblHashtag WHERE hashtag = ?";
			pstat = conn.prepareStatement(sql);
			pstat.setString(1, tagName);
			rs=pstat.executeQuery();
			
			//1. 태그가 존재하는지 확인
			if (rs.next()) {
				//존재 o -> 아무 일도 하지 않음
			} else {
				//존재 x
				//2. 태그 추가
				sql = "INSERT INTO tblHashtag (seq, hashtag) VALUES (seqHashtag.nextVal, ?)";
				pstat = conn.prepareStatement(sql);
				pstat.setString(1, tagName);
				pstat.executeUpdate();
			}
			//3. 태그 번호 반환
			//여기까지 오면 태그 테이블에 레코드가 하나 추가된 상태
			//insert 이후에 덮어써야해서.. 다시 입력
			sql = "SELECT seq FROM tblHashtag WHERE hashtag = ?";
			pstat = conn.prepareStatement(sql);
			pstat.setString(1, tagName);
			rs=pstat.executeQuery();
			
			if (rs.next()) {
				return rs.getString("seq");
			}
			
			
		} catch (Exception e) {
			// handle exception
			System.out.println("BoardDAO.addHashtag()");
			e.printStackTrace();
		}
		
		return null;
	}

	public void addTagging(Map<String, String> map) {
		// add.do에서 호출(태그 기능)
		
		try {

			String sql = "INSERT INTO tbltagging (seq, bseq, hseq) VALUES (seqTagging.nextVal, ?, ?)";

			pstat = conn.prepareStatement(sql);
			pstat.setString(1, map.get("bseq"));
			pstat.setString(2, map.get("hseq"));
			
			pstat.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	
	
	

}